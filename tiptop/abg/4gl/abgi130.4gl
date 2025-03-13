# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: abgi130.4gl
# Descriptions...: 部門費用項目會計維護作業
# Date & Author..: 02/09/30 By nicola
# Modify.........: No.FUN-4B0021 04/11/04 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-510025 05/01/17 By Smapmin 報表轉XML格式
# Modify.........: No.FUN-570108 05/07/13 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-660105 06/06/16 By hellen      cl_err --> cl_err3
# Modify.........: No.FUN-680061 06/08/25 By cheunl  欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0056 06/10/27 By jackho l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730033 07/03/19 By Carrier 會計科目加帳套
# Modify.........: No.FUN-820002 07/12/17 By lala  報表轉為使用p_query 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/14 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:FUN-D30032 13/04/02 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE 
      g_bgx           DYNAMIC ARRAY OF RECORD #程式變數(Program Variables)
      bgx01        LIKE bgx_file.bgx01,    #部門代碼
         bgx02        LIKE bgx_file.bgx02,    #直間接      
         bgx03        LIKE bgx_file.bgx03,    #費用項目
         bgs02        LIKE bgs_file.bgs02,    #費用項目名稱
         bgx04        LIKE bgx_file.bgx04,    #會計科目    
         bgxacti      LIKE bgx_file.bgxacti   #確認碼
                      END RECORD,
      g_bgx_t         RECORD                  #程式變數 (舊值)
      bgx01        LIKE bgx_file.bgx01,    #部門代碼
         bgx02        LIKE bgx_file.bgx02,    #直間接      
         bgx03        LIKE bgx_file.bgx03,    #費用項目
         bgs02        LIKE bgs_file.bgs02,    #費用項目名稱
         bgx04        LIKE bgx_file.bgx04,    #會計科目    
         bgxacti      LIKE bgx_file.bgxacti   #確認碼
                      END RECORD,
      g_wc2,g_sql     string,                     #No.FUN-580092 HCN
      g_rec_b         LIKE type_file.num5,        #單身筆數  #No.FUN-680061 SMALLINT
      l_ac            LIKE type_file.num5         #目前處理的ARRAY CNT  #No.FUN-680061 SMALLINT
DEFINE   g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL      
DEFINE   g_cnt           LIKE type_file.num10     #No.FUN-680061 INTEGER
DEFINE   g_i             LIKE type_file.num5      #count/index for any purpose #No.FUN-680061 SMALLINT
DEFINE   g_msg           LIKE ze_file.ze03        #No.FUN-680061 VARCHAR(72) 
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680061 SMALLINT
 
MAIN
   OPTIONS                                    #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                            #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABG")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0056
 
   OPEN WINDOW i130_w WITH FORM "abg/42f/abgi130"
      ATTRIBUTE(STYLE = g_win_style CLIPPED)
   CALL cl_ui_init() 
 
   CALL i130_menu() 
 
   CLOSE WINDOW i130_w                        #結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0056
END MAIN
 
FUNCTION i130_menu()
   WHILE TRUE                                                                   
      CALL i130_bp("G")                                                         
      CASE g_action_choice                                                      
         WHEN "query"                                                           
            IF cl_chk_act_auth() THEN                                           
               CALL i130_q()                                                    
            END IF                                                              
         WHEN "detail"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i130_b()                                                    
            ELSE                                                                
               LET g_action_choice = NULL                                       
            END IF                                                              
         WHEN "output"                                                          
            IF cl_chk_act_auth() THEN                                           
               CALL i130_out()                                                  
            END IF                                                              
         WHEN "help"                                                            
            CALL cl_show_help()                                                    
         WHEN "exit"                                                            
            EXIT WHILE                                                          
         WHEN "controlg"                                                        
            CALL cl_cmdask()
         WHEN "exporttoexcel"   #No.FUN-4B0021
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bgx),'','')
            END IF
      END CASE                                                                  
   END WHILE  
END FUNCTION
 
FUNCTION i130_q()
   CALL i130_b_askkey()
END FUNCTION
 
FUNCTION i130_b()
   DEFINE
      l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-680061 SMALLINT
      l_n             LIKE type_file.num5,   #檢查重複用 #No.FUN-680061 SMALLINT
      l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680061 VARCHAR(01)
      p_cmd           LIKE type_file.chr1,   #處理狀態   #No.FUN-680061 VARCHAR(01)
      l_allow_insert  LIKE type_file.num5,   #可新增否   #No.FUN-680061 VARCHAR(01)    
      l_allow_delete  LIKE type_file.num5    #可刪除否   #No.FUN-680061 VARCHAR(01)
   DEFINE  l_aag05    LIKE aag_file.aag05    #No.FUN-B40004 
 
   LET g_action_choice = "" 
 
   IF s_shut(0) THEN RETURN END IF
   CALL cl_opmsg('b')
 
   LET g_forupd_sql= "SELECT bgx01,bgx02,bgx03,'',bgx04,bgxacti FROM bgx_file ",
                     " WHERE bgx01=? AND bgx02=? AND bgx03=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i130_bcl CURSOR FROM g_forupd_sql    # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth('insert')                         
   LET l_allow_delete = cl_detail_input_auth('delete')  
 
       INPUT ARRAY g_bgx WITHOUT DEFAULTS FROM s_bgx.*
           ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,             
                      INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,   
                      APPEND ROW = l_allow_insert) 
 
      BEFORE INPUT                                                            
          IF g_rec_b != 0 THEN                                                
             CALL fgl_set_arr_curr(l_ac)                                      
          END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
 
         IF g_rec_b>=l_ac THEN
#No.FUN-570108--begin                                                           
            LET p_cmd='u'                                                       
            LET g_before_input_done = FALSE                                     
            CALL i130_set_entry(p_cmd)                                          
            CALL i130_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570108--end                    
            BEGIN WORK
            LET p_cmd='u'
            LET g_bgx_t.* = g_bgx[l_ac].*  #BACKUP
            OPEN i130_bcl USING g_bgx_t.bgx01,g_bgx_t.bgx02,g_bgx_t.bgx03   
            IF STATUS THEN                                                  
               CALL cl_err("OPEN i130_bcl:", STATUS, 1)                     
               LET l_lock_sw = "Y"                                          
            ELSE      
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_bgx_t.bgx01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH i130_bcl INTO g_bgx[l_ac].* 
               CALL i130_bgx03('d',g_bgx_t.bgx03)
                       RETURNING g_bgx[l_ac].bgs02
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108--begin                                                           
         LET g_before_input_done = FALSE                                         
         CALL i130_set_entry(p_cmd)                                              
         CALL i130_set_no_entry(p_cmd)                                           
         LET g_before_input_done = TRUE                                          
#No.FUN-570108--end                
         INITIALIZE g_bgx[l_ac].* TO NULL
         LET g_bgx_t.* = g_bgx[l_ac].*         #新輸入資料
         LET g_bgx[l_ac].bgxacti = 'Y'
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD bgx01
 
      AFTER INSERT                                                            
         IF INT_FLAG THEN                                                     
            CALL cl_err('',9001,0)                                            
            LET INT_FLAG = 0                                                  
            CANCEL INSERT                                                     
         END IF    
         INSERT INTO bgx_file(bgx01,bgx02,bgx03,bgx04,bgxacti,bgxoriu,bgxorig)
              VALUES(g_bgx[l_ac].bgx01,g_bgx[l_ac].bgx02,g_bgx[l_ac].bgx03,
                     g_bgx[l_ac].bgx04,g_bgx[l_ac].bgxacti, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_bgx[l_ac].bgx01,SQLCA.sqlcode,0) #FUN-660105
            CALL cl_err3("ins","bgx_file",g_bgx[l_ac].bgx01,g_bgx[l_ac].bgx02,SQLCA.sqlcode,"","",1) #FUN-660105
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            COMMIT WORK
         END IF
 
      AFTER FIELD bgx01                        #check 編號是否重複
         IF NOT cl_null(g_bgx[l_ac].bgx01) THEN
            CALL i130_bgx01('a',g_bgx[l_ac].bgx01)
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err('',g_errno,0)
               NEXT FIELD bgx01
            END IF
         END IF
 
      AFTER FIELD bgx03
         IF NOT cl_null(g_bgx[l_ac].bgx03) THEN
            IF g_bgx_t.bgx03 IS NULL OR g_bgx[l_ac].bgx03 != g_bgx_t.bgx03 THEN
               SELECT COUNT(*) INTO g_cnt
                 FROM bgx_file
                WHERE bgx01 = g_bgx[l_ac].bgx01  
                  AND bgx02 = g_bgx[l_ac].bgx02
                  AND bgx03 = g_bgx[l_ac].bgx03
               IF g_cnt > 0 THEN
                  CALL cl_err('','abg-003',0)
                  NEXT FIELD bgx03
               ELSE
                  CALL i130_bgx03('a',g_bgx[l_ac].bgx03)
                       RETURNING g_bgx[l_ac].bgs02
                  IF NOT cl_null(g_errno) THEN 
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD bgx03
                  END IF
               END IF
            END IF
         END IF
 
      AFTER FIELD bgx04                    #科目編號
         IF NOT cl_null(g_bgx[l_ac].bgx04) THEN
            IF g_bgx_t.bgx04 IS NULL OR g_bgx[l_ac].bgx04 != g_bgx_t.bgx04 THEN      
               SELECT COUNT(*) INTO g_cnt
                 FROM aag_file
                WHERE aag01=g_bgx[l_ac].bgx04 AND aag03 IN ('2')
                  AND aag07 IN ('2','3') AND aag09 IN ('Y')
                  AND aag00=g_aza.aza81  #No.FUN-730033
               IF g_cnt = 0 THEN
                  CALL cl_err('select aag',100,0)
                  #FUN-B10049--begin
                  CALL cl_init_qry_var()                                         
                  LET g_qryparam.form ="q_aag"                                   
                  LET g_qryparam.default1 = g_bgx[l_ac].bgx04  
                  LET g_qryparam.construct = 'N'                
                  LET g_qryparam.arg1 = g_aza.aza81  
                  LET g_qryparam.where = " aag07 IN ('2')  AND aag03 IN ('2','3') AND aag01 LIKE '",g_bgx[l_ac].bgx04 CLIPPED,"%' "                                                                        
                  CALL cl_create_qry() RETURNING g_bgx[l_ac].bgx04
                  DISPLAY BY NAME g_bgx[l_ac].bgx04  
                  #FUN-B10049--end
                  NEXT FIELD bgx04                                      
               END IF
            END IF
            #No.FUN-B40004  --Begin
            LET l_aag05=''
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01 = g_bgx[l_ac].bgx04
               AND aag00 = g_aza.aza81
            IF l_aag05 = 'Y' THEN
               #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
               IF g_aaz.aaz90 !='Y' THEN
                  LET g_errno = ' '
                  CALL s_chkdept(g_aaz.aaz72,g_bgx[l_ac].bgx04,g_bgx[l_ac].bgx01,g_aza.aza81)
                       RETURNING g_errno
               END IF
            END IF
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_bgx[l_ac].bgx04,g_errno,0)
               DISPLAY BY NAME g_bgx[l_ac].bgx04
               NEXT FIELD bgx04
            END IF
            #No.FUN-B40004  --End
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_bgx_t.bgx01) THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN                                         
               CALL cl_err("", -263, 1)                                     
               CANCEL DELETE                                                
            END IF   
            DELETE FROM bgx_file
             WHERE bgx01 = g_bgx_t.bgx01
               AND bgx02 = g_bgx_t.bgx02
               AND bgx03 = g_bgx_t.bgx03
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgx_t.bgx01,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("del","bgx_file",g_bgx_t.bgx01,g_bgx_t.bgx02,SQLCA.sqlcode,"","",1) #FUN-660105
               LET l_ac_t = l_ac
               EXIT INPUT
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
            COMMIT WORK
         END IF
 
      ON ROW CHANGE                                                           
         IF INT_FLAG THEN                 #新增程式段                         
            CALL cl_err('',9001,0)                                            
            LET INT_FLAG = 0                                                  
            LET g_bgx[l_ac].* = g_bgx_t.*                                     
            CLOSE i130_bcl                                                    
            ROLLBACK WORK                                                     
            EXIT INPUT                                                        
         END IF                                                               
                                                                              
         IF l_lock_sw="Y" THEN                                                
            CALL cl_err(g_bgx[l_ac].bgx01,-263,0)                             
            LET g_bgx[l_ac].* = g_bgx_t.*                                     
         ELSE 
            UPDATE bgx_file SET bgx01 = g_bgx[l_ac].bgx01,
                                bgx02 = g_bgx[l_ac].bgx02,
                                bgx03 = g_bgx[l_ac].bgx03,
                                bgx04 = g_bgx[l_ac].bgx04,
                                bgxacti = g_bgx[l_ac].bgxacti
             WHERE CURRENT OF i130_bcl
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bgx[l_ac].bgx01,SQLCA.sqlcode,0) #FUN-660105
               CALL cl_err3("upd","bgx_file",g_bgx[l_ac].bgx01,g_bgx[l_ac].bgx02,SQLCA.sqlcode,"","",1) #FUN-660105
               LET g_bgx[l_ac].* = g_bgx_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()                                               
        #LET l_ac_t = l_ac      #FUN-D30032 mark                                             
         IF INT_FLAG THEN                                                    
            CALL cl_err('',9001,0)                                           
            LET INT_FLAG = 0                                                 
            IF p_cmd = 'u' THEN                                              
               LET g_bgx[l_ac].* = g_bgx_t.*                                 
            #FUN-D30032--add--begin--
            ELSE
               CALL g_bgx.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end----
            END IF                                                           
            CLOSE i130_bcl                                                  
            ROLLBACK WORK                                                    
            EXIT INPUT                                                       
         END IF                                 
         LET l_ac_t = l_ac      #FUN-D30032 add                             
         CLOSE i130_bcl                                                     
         COMMIT WORK 
 
      ON ACTION CONTROLP                       #沿用所有欄位
         CASE
            WHEN INFIELD(bgx01)
            #  CALL q_gem(05,11,g_bgx[l_ac].bgx01) RETURNING g_bgx[l_ac].bgx01
               CALL cl_init_qry_var()            
               LET g_qryparam.form = "q_gem"             
               LET g_qryparam.default1 = g_bgx[l_ac].bgx01   
               CALL cl_create_qry() RETURNING g_bgx[l_ac].bgx01     
               NEXT FIELD bgx01
            WHEN INFIELD(bgx03)
            #  CALL q_bgs(05,11,g_bgx[l_ac].bgx03) RETURNING g_bgx[l_ac].bgx03
               CALL cl_init_qry_var()                                     
               LET g_qryparam.form = 'q_bgs'                                
               LET g_qryparam.default1 = g_bgx[l_ac].bgx03          
               CALL cl_create_qry() RETURNING g_bgx[l_ac].bgx03                 
               NEXT FIELD bgx03
            WHEN INFIELD(bgx04)
            #  CALL q_aag(10,3,g_bgx[l_ac].bgx04,'2','23','') RETURNING g_bgx[l_ac].bgx04
               CALL cl_init_qry_var()                                         
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgx[l_ac].bgx04                  
               LET g_qryparam.arg1 = g_aza.aza81  #No.FUN-730033
               LET g_qryparam.where = " aag07 IN ('2')  AND aag03 IN ('2','3')"                                                                        
               CALL cl_create_qry() RETURNING g_bgx[l_ac].bgx04
               DISPLAY BY NAME g_bgx[l_ac].bgx04  #No.FUN-730033
               NEXT FIELD bgx04
         END CASE
 
     ON ACTION CONTROLN                       #沿用所有欄位
        CALL i130_b_askkey()
        EXIT INPUT
 
      ON ACTION CONTROLO                       #沿用所有欄位
         IF INFIELD(bgx01) AND l_ac > 1 THEN
            LET g_bgx[l_ac].* = g_bgx[l_ac-1].*
            NEXT FIELD bgx01
         END IF
 
        ON ACTION CONTROLR                                                      
           CALL cl_show_req_fields()                                            
                                                                                
        ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       #沿用所有欄位
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
 
   CLOSE i130_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION i130_bgx01(p_cmd,p_key)  #部門編號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680061 VARCHAR(01)
           p_key     LIKE bgv_file.bgv04,
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
END FUNCTION
FUNCTION i130_bgx03(p_cmd,p_key)
DEFINE
    p_cmd           LIKE type_file.chr1,     #No.FUN-680061 VARCHAR(01)
    p_key           LIKE bgs_file.bgs01,
    l_bgs02         LIKE bgs_file.bgs02,
    l_bgsacti       LIKE bgs_file.bgsacti
 
    LET g_errno = ' '
    SELECT bgs02,bgsacti INTO l_bgs02,l_bgsacti
      FROM bgs_file
     WHERE bgs01 = p_key
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'abg-004'
                                   LET l_bgs02   = NULL
                                   LET l_bgsacti = NULL
         WHEN l_bgsacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN l_bgs02
END FUNCTION
 
FUNCTION i130_b_askkey()
   CLEAR FORM
   CALL g_bgx.clear()
   CONSTRUCT g_wc2 ON bgx01,bgx02,bgx03,bgx04,bgxacti
        FROM s_bgx[1].bgx01,s_bgx[1].bgx02,s_bgx[1].bgx03,s_bgx[1].bgx04,s_bgx[1].bgxacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP                       #沿用所有欄位
         CASE
            WHEN INFIELD(bgx01)
            #  CALL q_gem(05,11,g_bgx[l_ac].bgx01) RETURNING g_bgx[l_ac].bgx01
               CALL cl_init_qry_var()            
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_gem"             
               CALL cl_create_qry() RETURNING g_qryparam.multiret       
               DISPLAY g_qryparam.multiret TO s_bgx[1].bgx01
               NEXT FIELD bgx01
            WHEN INFIELD(bgx03)
            #  CALL q_bgs(05,11,g_bgx[l_ac].bgx03) RETURNING g_bgx[l_ac].bgx03
               CALL cl_init_qry_var()                                     
               LET g_qryparam.state = "c"
               LET g_qryparam.form = 'q_bgs'                                
               CALL cl_create_qry() RETURNING g_qryparam.multiret       
               DISPLAY g_qryparam.multiret TO s_bgx[1].bgx03
               NEXT FIELD bgx03
            WHEN INFIELD(bgx04)
            #  CALL q_aag(10,3,g_bgx[l_ac].bgx04,'2','23','') RETURNING g_bgx[l_ac].bgx04
               CALL cl_init_qry_var()                                         
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aag"                                   
               LET g_qryparam.default1 = g_bgx[l_ac].bgx04                  
               LET g_qryparam.where = " aag07 IN ('2')  AND aag03 IN ('2','3')"                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret       
               DISPLAY g_qryparam.multiret TO s_bgx[1].bgx04
               NEXT FIELD bgx04
         END CASE
            ON IDLE g_idle_seconds                                              
               CALL cl_on_idle()                                                
               CONTINUE CONSTRUCT                                               
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('bgxuser', 'bgxgrup') #FUN-980030
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
   CALL i130_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i130_b_fill(p_wc2)              #BODY FILL UP
   DEFINE
      p_wc2           LIKE type_file.chr1000       #No.FUN-680061 VARCHAR(200)
 
   LET g_sql = "SELECT bgx01,bgx02,bgx03,'',bgx04,bgxacti",
               " FROM bgx_file",
               " WHERE ", p_wc2 CLIPPED,                     #單身
               " ORDER BY bgx01,bgx03,bgx02"
   PREPARE i130_pb FROM g_sql
   DECLARE bgx_curs CURSOR FOR i130_pb
 
   CALL g_bgx.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" ATTRIBUTE(REVERSE)
 
   FOREACH bgx_curs INTO g_bgx[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      CALL i130_bgx03('d',g_bgx[g_cnt].bgx03) RETURNING g_bgx[g_cnt].bgs02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_bgx.deleteElement(g_cnt) 
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
   LET g_cnt=0
END FUNCTION
 
FUNCTION i130_bp(p_ud)
   DEFINE
      p_ud            LIKE type_file.chr1    #No.FUN-680061 VARCHAR(01)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                           
                                                                                
      RETURN                                                                    
   END IF                                                                       
                                                                                
   LET g_action_choice = " "                                                    
                                                                                
   CALL cl_set_act_visible("accept,cancel", FALSE)                              
   DISPLAY ARRAY g_bgx TO s_bgx.* ATTRIBUTE(COUNT=g_rec_b)                      
                                                                                
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
      ON ACTION locale                                                          
         CALL cl_dynamic_locale()                                               
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                                                                                
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
#No.FUN-820002--start--
FUNCTION i130_out()
   DEFINE l_cmd  LIKE type_file.chr1000
#   DEFINE
#       l_i    LIKE type_file.num5,    #No.FUN-680061 SMALLINT
#       l_name LIKE type_file.chr20,   # External(Disk) file name #NO.FUN-680061 VARCHAR(20)
#       l_za05 LIKE type_file.chr1000, #NO.FUN-680061 VARCHAR(40)  
#       sr RECORD
#          bgx01      LIKE bgx_file.bgx01,
#          bgx02      LIKE bgx_file.bgx02,
#          bgx03      LIKE bgx_file.bgx03,
#          bgx04      LIKE bgx_file.bgx04,
#          bgxacti    LIKE bgx_file.bgxacti,
#          bgs02      LIKE bgs_file.bgs02 
#       END RECORD
#  
 
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0)
    RETURN END IF
    LET l_cmd = 'p_query "abgi130" "',g_wc2 CLIPPED,'" "',g_aza.aza81 CLIPPED,'"'
    CALL cl_cmdrun(l_cmd)
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM bgx_file ",          # 組合出 SQL 指令
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i130_p1 FROM g_sql                # RUNTIME 編譯
#   DECLARE i130_co                         # SCROLL CURSOR
#        CURSOR FOR i130_p1
 
#   CALL cl_outnam('abgi130') RETURNING l_name
#   START REPORT i130_rep TO l_name
 
#   FOREACH i130_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#       END IF
#       CALL i130_bgx03('d',sr.bgx03) RETURNING sr.bgs02
#       OUTPUT TO REPORT i130_rep(sr.*)
#   END FOREACH
 
#   FINISH REPORT i130_rep
 
#   CLOSE i130_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i130_rep(sr)
#   DEFINE
#       l_trailer_sw  LIKE type_file.chr1,   #No.FUN-680061 VARCHAR(01)
#       l_gem02       LIKE gem_file.gem02,
#       l_aag02       LIKE aag_file.aag02,
#       sr RECORD
#          bgx01      LIKE bgx_file.bgx01,
#          bgx02      LIKE bgx_file.bgx02,
#          bgx03      LIKE bgx_file.bgx03,
#          bgx04      LIKE bgx_file.bgx04,
#          bgxacti    LIKE bgx_file.bgxacti,
#          bgs02      LIKE bgs_file.bgs02 
#       END RECORD
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.bgx01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1] CLIPPED
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<',"/pageno"
#           PRINT g_head CLIPPED, pageno_total
#           PRINT g_dash[1,g_len]
#           PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#           SELECT gem02 INTO l_gem02 FROM gem_file WHERE gem01=sr.bgx01
#           SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=sr.bgx04
#                         AND aag00=g_aza.aza81  #No.FUN-730033
#           PRINT COLUMN g_c[31],sr.bgx01 CLIPPED,
#                 COLUMN g_c[32],l_gem02  CLIPPED,
#                 COLUMN g_c[33],sr.bgx02 CLIPPED,
#                 COLUMN g_c[34],sr.bgx03 CLIPPED,
#                 COLUMN g_c[35],sr.bgs02 CLIPPED,
#                 COLUMN g_c[36],sr.bgx04 CLIPPED,
#                 COLUMN g_c[37],l_aag02 CLIPPED,
#                 COLUMN g_c[38],sr.bgxacti
 
#       ON LAST ROW
#           PRINT g_dash[1,g_len]
#           PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash[1,g_len]
#               PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-820002--end--
#No.FUN-570108--begin                                                           
FUNCTION i130_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("bgx01,bgx02,bgx03",TRUE)                           
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i130_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680061 VARCHAR(01)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("bgx01,bgx02,bgx03",FALSE)                          
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108--end                         
