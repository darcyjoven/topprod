# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: cxci900.4gl
# Descriptions...: 客制成本期末结存调整作业
# Date & Author..: 17/07/28 By luoyb
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_ex_imk           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        ex_imk01       LIKE imk_file.imk01,  
        ex_imk02       LIKE imk_file.imk01,
        ex_imk03       LIKE imk_file.imk01,
        ex_imk04       LIKE imk_file.imk01,
        ex_imk09       LIKE imk_file.imk09,
        ex_tot         LIKE imk_file.imk09,
        ex_bl          DEC(20,8)
                    END RECORD,
    g_ex_imk_t         RECORD                 #程式變數 (舊值)
        ex_imk01       LIKE imk_file.imk01,  
        ex_imk02       LIKE imk_file.imk01,
        ex_imk03       LIKE imk_file.imk01,
        ex_imk04       LIKE imk_file.imk01,
        ex_imk09       LIKE imk_file.imk09,
        ex_tot         LIKE imk_file.imk09,
        ex_bl          DEC(20,8)
                    END RECORD,
    g_wc2,g_sql    STRING,  #No.FUN-580092 HCN     
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE tm                    RECORD
       yy                    LIKE type_file.num5,
       mm                    LIKE type_file.num5
       END RECORD
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109          #No.FUN-680137 SMALLINT
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CXC")) THEN
      EXIT PROGRAM
   END IF
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 3 LET p_col = 13
 
    OPEN WINDOW i900_w AT p_row,p_col WITH FORM "cxc/42f/cxci900"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()

    CALL i900_menu()
    CLOSE WINDOW i900_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i900_menu()
 
   WHILE TRUE
      CALL i900_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i900_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i900_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "help"
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ex_imk),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i900_q()
   CALL i900_b_askkey()
END FUNCTION
 
FUNCTION i900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ex_imk01,ex_imk02,ex_imk03,ex_imk04,ex_imk09,ex_tot,ex_bl FROM ex_imk_file ",
                       " WHERE ex_imk01=? AND ex_imk02=? AND ex_imk03=? AND ex_imk04=? ",
                       "   AND ex_imk05 = ",tm.yy," AND ex_imk06 = ",tm.mm," FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = FALSE 
        LET l_allow_delete = FALSE
 
        INPUT ARRAY g_ex_imk WITHOUT DEFAULTS FROM s_ex_imk.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_ex_imk_t.* = g_ex_imk[l_ac].*  #BACKUP
 
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i900_set_entry_b(p_cmd)                                                                                         
               CALL i900_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--  
               BEGIN WORK
 
               OPEN i900_bcl USING g_ex_imk_t.ex_imk01,g_ex_imk_t.ex_imk02,
                                   g_ex_imk_t.ex_imk03,g_ex_imk_t.ex_imk04
               IF STATUS THEN
                  CALL cl_err("OPEN i900_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i900_bcl INTO g_ex_imk[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ex_imk_t.ex_imk01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
          AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i900_set_entry_b(p_cmd)                                                                                         
            CALL i900_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--  
            INITIALIZE g_ex_imk[l_ac].* TO NULL      #900423
            LET g_ex_imk_t.* = g_ex_imk[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        BEFORE DELETE                            #是否取消單身

        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ex_imk[l_ac].* = g_ex_imk_t.*
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ex_imk[l_ac].ex_imk01,-263,1)
               LET g_ex_imk[l_ac].* = g_ex_imk_t.*
            ELSE
               UPDATE ex_imk_file SET ex_imk09=g_ex_imk[l_ac].ex_imk09
                WHERE ex_imk01 = g_ex_imk_t.ex_imk01
                  AND ex_imk02 = g_ex_imk_t.ex_imk02
                  AND ex_imk03 = g_ex_imk_t.ex_imk03
                  AND ex_imk04 = g_ex_imk_t.ex_imk04
                  AND ex_imk05 = tm.yy
                  AND ex_imk06 = tm.mm
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","ex_imk_file",g_ex_imk_t.ex_imk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_ex_imk[l_ac].* = g_ex_imk_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    CLOSE i900_bcl
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ex_imk[l_ac].* = g_ex_imk_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_ex_imk.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034 add
            CLOSE i900_bcl
            COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ex_imk01) AND l_ac > 1 THEN
                LET g_ex_imk[l_ac].* = g_ex_imk[l_ac-1].*
                NEXT FIELD ex_imk01
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
 
    CLOSE i900_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i900_b_askkey()
    CLEAR FORM
    CALL g_ex_imk.clear()
    INITIALIZE tm.* TO NULL   
    SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00 = '0'
    
    DIALOG ATTRIBUTES(UNBUFFERED)
    
    INPUT BY NAME tm.yy,tm.mm
       BEFORE INPUT                                    #預設查詢條件
           LET tm.yy = g_ccz.ccz01
           LET tm.mm = g_ccz.ccz02
           DISPLAY BY NAME tm.yy,tm.mm
           CALL cl_qbe_init()                          #讀回使用者存檔的預設條件 

       AFTER FIELD yy 
         IF tm.yy < 2017 THEN
            CALL cl_err('无法修改2017年之前资料,请重新输入','!',1)
            NEXT FIELD yy
         END IF
    END INPUT

    CONSTRUCT g_wc2 ON ex_imk01,ex_imk04
            FROM s_ex_imk[1].ex_imk01,s_ex_imk[1].ex_imk04
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
    END CONSTRUCT
    
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE DIALOG

        ON ACTION controlp
                CASE
                   WHEN INFIELD(ex_imk01) #产品编号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ima"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ex_imk01
                        NEXT FIELD ex_imk01
                  WHEN INFIELD(ex_imk04) #产品编号
                        CALL cl_init_qry_var()
                        LET g_qryparam.state = "c"
                        LET g_qryparam.form ="q_ima"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ex_imk04
                        NEXT FIELD ex_imk04
                END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()

             ON ACTION accept
                EXIT DIALOG

             ON ACTION EXIT
                LET INT_FLAG = TRUE
                EXIT DIALOG

             ON ACTION cancel
                LET INT_FLAG = TRUE
                EXIT DIALOG
            END DIALOG
           
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null)

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF

    CALL i900_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    LET g_sql =
        "SELECT ex_imk01,ex_imk02,ex_imk03,ex_imk04,ex_imk09,ex_tot,ex_bl",
        " FROM ex_imk_file ",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        "   AND ex_imk05 = ",tm.yy,
        "   AND ex_imk06 = ",tm.mm,
        "   AND ex_imk01 <> ex_imk04 ",
        " ORDER BY ex_imk01"
    PREPARE i900_pb FROM g_sql
    DECLARE ex_imk_curs CURSOR FOR i900_pb
 
    CALL g_ex_imk.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ex_imk_curs INTO g_ex_imk[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_ex_imk.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ex_imk TO s_ex_imk.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
   
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i900_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
        {                                                                                                                            
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("ex_imk01",TRUE)                                                                                           
  END IF                                                                                                                            
              }                                                                                                                      
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i900_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
                    {                                                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("ex_imk01",FALSE)                                                                                          
   END IF                                                                                                                           
                 }                                                                                                                   
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--     
