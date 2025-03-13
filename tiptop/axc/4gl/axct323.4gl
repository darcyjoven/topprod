# Prog. Version..: '5.30.06-13.04.25(00006)'     #
#
# Pattern name.... axct323.4gl
# Descriptions.... 
# Date & Author... 2010/07/02 By wujie #No.FUN-AA0025
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:FUN-BB0038 11/11/09 By elva 成本改善
# Modify.........: No:TQC-BC0148 11/12/26 By elva 成本改善
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-CC0001 13/02/05 By wujie 增加串查凭证资料
# Modify.........: No:FUN-D40030 13/04/09 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40121 13/06/24 By zhangweib 增加傳參

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-AA0025
#模組變數(Module Variables)
DEFINE
    g_cdk_h         RECORD LIKE cdk_file.*,    #(假單頭)
    g_cdk           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        cdk05            LIKE cdk_file.cdk05,        
        cdk11            LIKE cdk_file.cdk11,
        cdk06            LIKE cdk_file.cdk06,
        ima02            LIKE ima_file.ima02,  
        cdk13            LIKE cdk_file.cdk13,
        aag02_2          LIKE aag_file.aag02, 
        cdk07            LIKE cdk_file.cdk07,
        aag02            LIKE aag_file.aag02,
        cdk08            LIKE cdk_file.cdk08,
        cdk09            LIKE cdk_file.cdk09
                    END RECORD,
    g_cdk_t         RECORD                 #程式變數 (舊值)
        cdk05            LIKE cdk_file.cdk05,        
        cdk11            LIKE cdk_file.cdk11,
        cdk06            LIKE cdk_file.cdk06,
        ima02            LIKE ima_file.ima02,  
        cdk13            LIKE cdk_file.cdk13,
        aag02_2          LIKE aag_file.aag02,
        cdk07            LIKE cdk_file.cdk07,
        aag02            LIKE aag_file.aag02,
        cdk08            LIKE cdk_file.cdk08,
        cdk09            LIKE cdk_file.cdk09
                    END RECORD,
    g_wcg_sql           string,  #No.FUN-580092 HCN
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
    m_cdk               RECORD LIKE cdk_file.*,
    l_ac,l_ac1          LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
 
 
#主程式開始
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_str           STRING     #No.FUN-670060
DEFINE  g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72) 
DEFINE  g_row_count     LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_curs_index    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  g_jump          LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE  mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT                                                                
DEFINE  g_wc,g_sql      string 
DEFINE  g_nppglno       LIKE npp_file.nppglno
DEFINE  g_wc1           STRING     #No.FUN-D40121   Add

MAIN
DEFINE l_time           LIKE type_file.chr8           
DEFINE p_row,p_col      LIKE type_file.num5  

   OPTIONS                              
      INPUT NO WRAP                    
   DEFER INTERRUPT                    

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

  #No.FUN-D40121 ---Add--- Start
   LET g_wc1 = ARG_VAL(1)
   LET g_wc1 = cl_replace_str(g_wc1, "\\\"", "'")
  #No.FUN-D40121 ---Add--- End
 
   WHENEVER ERROR CONTINUE 
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF

#   CALL cl_used(g_prog,l_time,1)       
#      RETURNING l_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   LET g_forupd_sql = "SELECT * FROM cdk_file WHERE cdk01 = ? AND cdk02 = ? AND cdk03 = ? AND cdk04 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t323_cl CURSOR FROM g_forupd_sql

   LET p_row = 2 LET p_col = 9

   OPEN WINDOW t323_w AT p_row,p_col WITH FORM "axc/42f/axct323"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)

   CALL cl_ui_init()

   CALL cl_set_comp_visible("cdk13,aag02_2",FALSE) #FUN-BB0038  #TQC-BC0148

  #No.FUN-D40121 ---Add--- Start
   IF NOT cl_null(g_wc1) THEN
      CALL t323_q()
   END IF
  #No.FUN-D40121 ---Add--- End

   CALL t323_menu()
   CLOSE WINDOW t323_w               

#   CALL cl_used(g_prog,l_time,2)       
#      RETURNING l_time
  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN

#QBE 查詢資料
FUNCTION t323_cs()
DEFINE   l_type      LIKE apa_file.apa00    
DEFINE   l_dbs       LIKE type_file.chr21  
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01  
 
   CLEAR FORM                             #清除畫面
   CALL g_cdk.clear()

 
      CALL cl_set_head_visible("","YES")          
      IF cl_null(g_wc1) THEN   #No.FUN-D40121   Add
      INITIALIZE g_cdk_h.* TO NULL     
         CONSTRUCT BY NAME g_wc ON cdk04,cdk01,cdklegal,cdk02,cdk03,cdk10
         BEFORE CONSTRUCT
             CALL cl_qbe_init()                    
  

         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(cdk01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO cdk01
                  NEXT FIELD cdk01
               OTHERWISE EXIT CASE
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
         
         ON ACTION qbe_select
            CALL cl_qbe_list() RETURNING lc_qbe_sn
            CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION accept
               EXIT CONSTRUCT
         
         ON ACTION EXIT
            LET INT_FLAG = TRUE
            EXIT CONSTRUCT 
          
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT CONSTRUCT 
      END CONSTRUCT 
    END IF   #No.FUN-D40121   Add
      
   IF cl_null(g_wc) THEN
      LET g_wc =' 1=1' 
   END IF  

   IF cl_null(g_wc1) THEN LET g_wc1 = " 1=1" END IF   #No.FUN-D40121   Add
 
   LET g_sql = "SELECT UNIQUE cdk01,cdk02,cdk03,cdk04 ",
               "  FROM cdk_file",
               " WHERE  ", g_wc CLIPPED,
               "   AND ", g_wc1 CLIPPED,    #No.FUN-D40121   Add
               " ORDER BY cdk01,cdk02,cdk03,cdk04"

 
   PREPARE t323_prepare FROM g_sql
   DECLARE t323_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t323_prepare
 
END FUNCTION

FUNCTION t323_menu()
DEFINE l_ccz12    LIKE ccz_file.ccz12
DEFINE l_npptype  LIKE npp_file.npptype
 
   WHILE TRUE
      CALL t323_bp("G")
      CASE g_action_choice 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t323_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t323_r()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t323_b()
            ELSE
               LET g_action_choice = NULL
            END IF

         WHEN "gen_entry"
            CALL t323_v()
 
         WHEN "entry_sheet" 
            SELECT ccz12 INTO l_ccz12 FROM ccz_file 
            IF g_cdk_h.cdk01 = l_ccz12 THEN 
               LET l_npptype =0
            ELSE
               LET l_npptype =1
            END IF            
            CALL s_fsgl('CA',5,g_cdk_h.cdk10,0,g_cdk_h.cdk01,'1',g_cdk_h.cdkconf,l_npptype,g_cdk_h.cdk10)  

         WHEN "drill_down1"
            IF cl_chk_act_auth() THEN
               CALL t323_drill_down()
            END IF

         WHEN "confirm"
            CALL t323_firm1_chk()                     
            IF g_success = "Y" THEN
               CALL t323_firm1_upd()                   
            END IF
            CALL t323_show()         
         WHEN "undo_confirm" 
            CALL t323_firm2()
            CALL t323_show()

         WHEN "process_qry"  
            CALL cl_cmdrun_wait("axcp323")

         WHEN "carry_voucher"
            IF g_cdk_h.cdkconf ='Y' THEN
               LET g_msg ="axcp301 ",g_cdk_h.cdk10," '' '' '' ",
                          "'' '' '' 'N' '' ''"
               CALL cl_wait()
               CALL cl_cmdrun_wait(g_msg)
               SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdk_h.cdk10 AND nppsys ='CA' AND npp00 =5 AND npp011 =1
               DISPLAY g_nppglno TO nppglno
            END IF


         WHEN "undo_carry_voucher"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            LET g_msg ="axcp302 '",g_plant,"' '",g_cdk_h.cdk01,"' '",g_nppglno CLIPPED,"' 'Y'"
            CALL cl_wait()
            CALL cl_cmdrun_wait(g_msg)
            SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdk_h.cdk10 AND nppsys ='CA' AND npp00 =5 AND npp011 =1
            DISPLAY g_nppglno TO nppglno

#No.FUN-CC0001 --begin
         WHEN "voucher_qry"
            IF cl_null(g_nppglno) THEN EXIT CASE END IF
            CALL s_voucher_qry(g_nppglno)
#No.FUN-CC0001 --end

      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t323_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cdk_h.* TO NULL               
 
   CALL cl_msg("")                          
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_cdk.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t323_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")              #FUN-640240
 
   OPEN t323_cs                              #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_cdk_h.* TO NULL
   ELSE
      CALL t323_count()
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t323_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                              #FUN-640240
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t323_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t323_cs INTO g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04
      WHEN 'P' FETCH PREVIOUS t323_cs INTO g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04
      WHEN 'F' FETCH FIRST    t323_cs INTO g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04
      WHEN 'L' FETCH LAST     t323_cs INTO g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,'. ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #MOD-4C0121
                  CALL cl_about()      #MOD-4C0121
 
               ON ACTION help          #MOD-4C0121
                  CALL cl_show_help()  #MOD-4C0121
 
               ON ACTION controlg      #MOD-4C0121
                  CALL cl_cmdask()     #MOD-4C0121
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t323_cs INTO g_cdk_h.cdk01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdk_h.cdk01,SQLCA.sqlcode,0)
      INITIALIZE g_cdk_h.* TO NULL  #TQC-6B0105
      RETURN
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
   SELECT  DISTINCT cdk01,cdk02,cdk03,cdk04,cdk10,cdklegal,cdkconf INTO g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04,g_cdk_h.cdk10,g_cdk_h.cdklegal,g_cdk_h.cdkconf
     FROM  cdk_file WHERE cdk01 = g_cdk_h.cdk01 AND cdk02 = g_cdk_h.cdk02 AND cdk03 = g_cdk_h.cdk03 AND cdk04 = g_cdk_h.cdk04 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","cdk_file",g_cdk_h.cdk01,"",SQLCA.sqlcode,"","",1)  
      INITIALIZE g_cdk_h.* TO NULL
      RETURN
   ELSE   
      CALL t323_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t323_show()
DEFINE l_azt02    LIKE azt_file.azt02

   DISPLAY BY NAME 
          g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04,
          g_cdk_h.cdk10,g_cdk_h.cdklegal,g_cdk_h.cdkconf
   SELECT azt02 INTO l_azt02 FROM azt_file WHERE azt01 = g_cdk_h.cdklegal
   SELECT nppglno INTO g_nppglno FROM npp_file WHERE npp01 = g_cdk_h.cdk10 AND nppsys ='CA' AND npp00 =5 AND npp011 =1
   CALL cl_set_field_pic(g_cdk_h.cdkconf,"","","","","")
   DISPLAY l_azt02 TO azt02
   DISPLAY g_nppglno TO nppglno       
   CALL t323_b_fill()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t323_r()
DEFINE l_cnt            LIKE type_file.num5       
 
   IF NOT cl_null(g_nppglno) THEN CALL cl_err('','afa-973',1) RETURN END IF 
   IF g_cdk_h.cdk01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_cdk_h.cdkconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t323_cl USING g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04
   IF STATUS THEN
      CALL cl_err("OPEN t323_cl.", STATUS, 1)
      CLOSE t323_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t323_cl INTO g_cdk_h.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cdk_h.cdk01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t323_show()
   IF cl_delh(0,0) THEN                   #確認一下
      INITIALIZE g_doc.* TO NULL                       
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt 
        FROM cdk_file
       WHERE cdk01 = g_cdk_h.cdk01 
         AND cdk02 = g_cdk_h.cdk02
         AND cdk03 = g_cdk_h.cdk03
         AND cdk04 = g_cdk_h.cdk04
      IF l_cnt > 0 THEN
         DELETE FROM cdk_file 
          WHERE cdk01 = g_cdk_h.cdk01
            AND cdk02 = g_cdk_h.cdk02
            AND cdk03 = g_cdk_h.cdk03
            AND cdk04 = g_cdk_h.cdk04
            
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","cdk_file",g_cdk_h.cdk01,"",SQLCA.sqlcode,"","del cdk.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npp_file
       WHERE npp01 = g_cdk_h.cdk10
         AND nppsys= 'CA'
         AND npp00 = 5
         AND npp011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npp_file
          WHERE npp01 = g_cdk_h.cdk10
            AND nppsys= 'CA'
            AND npp00 = 5
            AND npp011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npp_file",g_cdk_h.cdk01,"",SQLCA.sqlcode,"","del npp.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_cdk_h.cdk10
         AND npqsys= 'CA'
         AND npq00 = 5
         AND npq011= 1
      IF l_cnt > 0 THEN
         DELETE FROM npq_file
          WHERE npq01 = g_cdk_h.cdk10
            AND npqsys= 'CA'
            AND npq00 = 5
            AND npq011= 1
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
            CALL cl_err3("del","npq_file",g_cdk_h.cdk01,"",SQLCA.sqlcode,"","del npq.",1)  #No.FUN-660122
            ROLLBACK WORK
            RETURN
         END IF
      END IF   #MOD-870048 add
      #FUN-B40056  --begin
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tic_file
       WHERE tic04 = g_cdk_h.cdk10
      IF l_cnt > 0 THEN
         DELETE FROM tic_file
          WHERE tic04 = g_cdk_h.cdk10
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_cdk_h.cdk10,"",SQLCA.sqlcode,"","del tic.",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF
      #FUN-B40056  --end
      INITIALIZE g_cdk_h.* TO NULL
      CLEAR FORM
      CALL g_cdk.clear()
      CALL t323_count()      
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t323_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t323_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t323_fetch('/')
      END IF
   END IF
   CLOSE t323_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_cdk_h.cdk01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 

 
FUNCTION t323_b()
DEFINE l_ac_t          LIKE type_file.num5,     #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
       l_n             LIKE type_file.num5,     #檢查重複用  #No.FUN-690028 SMALLINT
       l_lock_sw       LIKE type_file.chr1,     #單身鎖住否  #No.FUN-690028 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,     #處理狀態  #No.FUN-690028 VARCHAR(1)
       l_exit_sw       LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
       l_allow_insert  LIKE type_file.num5,     #可新增否  #No.FUN-690028 SMALLINT
       l_allow_delete  LIKE type_file.num5,     #可刪除否  #No.FUN-690028 SMALLINT
       l_cnt           LIKE type_file.num5      #MOD-650097  #No.FUN-690028 SMALLINT
       

   LET g_action_choice = ""
   IF g_cdk_h.cdk01 IS NULL THEN RETURN END IF
   IF g_cdk_h.cdkconf = 'Y' THEN
      CALL cl_err('','aap-086',0)
      RETURN
   END IF

   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT cdk05,cdk11,cdk06,'',cdk13,'',cdk07,'',cdk08,cdk09", 
                      " FROM cdk_file",
                      " WHERE cdk01=? AND cdk02=? AND cdk03 = ? AND cdk04 = ? AND cdk05 = ? AND cdk06 = ?  FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t323_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_exit_sw = 'y'
   INPUT ARRAY g_cdk WITHOUT DEFAULTS FROM s_cdk.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=TRUE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_cdk_t.* = g_cdk[l_ac].*  #BACKUP
             OPEN t323_b2cl USING g_cdk_h.cdk01,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk04,g_cdk_t.cdk05,g_cdk_t.cdk06
             IF STATUS THEN
                CALL cl_err("OPEN t323_b2cl.", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t323_b2cl INTO g_cdk[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_cdk_h.cdk02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             SELECT aag02 INTO g_cdk[l_ac].aag02 FROM aag_file WHERE aag01 = g_cdk[l_ac].cdk07 AND aag00 = g_cdk_h.cdk01
             SELECT aag02 INTO g_cdk[l_ac].aag02_2 FROM aag_file WHERE aag01 = g_cdk[l_ac].cdk13 AND aag00 = g_cdk_h.cdk01
             NEXT FIELD cdk13
          END IF

       BEFORE INSERT  
       
       AFTER INSERT 

       AFTER FIELD cdk06           
          IF g_cdk[l_ac].cdk06 IS NULL THEN
             LET g_cdk[l_ac].cdk06 = g_cdk_t.cdk06
             NEXT FIELD cdk06
          END IF
          IF g_cdk_t.cdk06 IS NULL OR g_cdk[l_ac].cdk06 <> g_cdk_t.cdk06 THEN 
             SELECT ima02 INTO g_cdk[l_ac].ima02
               FROM ima_file 
              WHERE ima01 = g_cdk[l_ac].cdk06             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdk[l_ac].cdk06,SQLCA.sqlcode,1)
                LET g_cdk[l_ac].cdk06 = g_cdk_t.cdk06
                NEXT FIELD cdk06
             END IF 
          END IF
         
       AFTER FIELD cdk07           
          IF g_cdk[l_ac].cdk07 IS NULL THEN
             LET g_cdk[l_ac].cdk07 = g_cdk_t.cdk07
             NEXT FIELD cdk07
          END IF
          IF g_cdk_t.cdk07 IS NULL OR g_cdk[l_ac].cdk07 <> g_cdk_t.cdk07 THEN 
             SELECT aag02 INTO g_cdk[l_ac].aag02
               FROM aag_file 
              WHERE aag01 = g_cdk[l_ac].cdk07 
                AND aag00 = g_cdk_h.cdk01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdk[l_ac].cdk07,SQLCA.sqlcode,1)
                LET g_cdk[l_ac].cdk07 = g_cdk_t.cdk07
                NEXT FIELD cdk07
             END IF 
          END IF 

       AFTER FIELD cdk13           
          IF g_cdk[l_ac].cdk13 IS NULL THEN
             LET g_cdk[l_ac].cdk13 = g_cdk_t.cdk13
             NEXT FIELD cdk13
          END IF
          IF g_cdk_t.cdk13 IS NULL OR g_cdk[l_ac].cdk13 <> g_cdk_t.cdk13 THEN 
             SELECT aag02 INTO g_cdk[l_ac].aag02_2
               FROM aag_file 
              WHERE aag01 = g_cdk[l_ac].cdk13 
                AND aag00 = g_cdk_h.cdk01             
             IF SQLCA.sqlcode THEN 
                CALL cl_err(g_cdk[l_ac].cdk13,SQLCA.sqlcode,1)
                LET g_cdk[l_ac].cdk13 = g_cdk_t.cdk13
                NEXT FIELD cdk13
             END IF 
          END IF 
 

       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac      #FUN-D40030 Mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             #FUN-D40030--add--str--
             IF p_cmd = 'u' THEN
                LET g_cdk[l_ac].* = g_cdk_t.*
             ELSE
                CALL g_cdk.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             END IF
             #FUN-D40030--add--end--
             CLOSE t323_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac      #FUN-D40030 Add
          CLOSE t323_b2cl
          COMMIT WORK

 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_cdk[l_ac].* = g_cdk_t.*
             CLOSE t323_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_cdk[l_ac].cdk06,-263,1)
             LET g_cdk[l_ac].* = g_cdk_t.*
          ELSE  
             UPDATE cdk_file SET cdk07 = g_cdk[l_ac].cdk07
              WHERE cdk01 = g_cdk_h.cdk01 
                AND cdk02 = g_cdk_h.cdk02
                AND cdk03 = g_cdk_h.cdk03
                AND cdk04 = g_cdk_h.cdk04 
                AND cdk05 = g_cdk_t.cdk05
                AND cdk06 = g_cdk_t.cdk06 

             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN   #CHI-850023
                CALL cl_err3("upd","cdk_file",g_cdk_h.cdk01,g_cdk_h.cdk02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                LET g_cdk[l_ac].* = g_cdk_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
    
 
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(cdk07) AND l_ac > 1 THEN
          END IF
 

       ON ACTION CONTROLP
          IF INFIELD(cdk07) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdk_h.cdk01
             LET g_qryparam.default1 = g_cdk[l_ac].cdk07
             CALL cl_create_qry() RETURNING g_cdk[l_ac].cdk07
             DISPLAY g_cdk[l_ac].cdk07 TO cdk07
             NEXT FIELD cdk07
          END IF  
          IF INFIELD(cdk13) THEN 
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_aag02"   
             LET g_qryparam.arg1 = g_cdk_h.cdk01
             LET g_qryparam.default1 = g_cdk[l_ac].cdk13
             CALL cl_create_qry() RETURNING g_cdk[l_ac].cdk13
             DISPLAY g_cdk[l_ac].cdk13 TO cdk13
             NEXT FIELD cdk13
          END IF  
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
 
       ON IDLE g_idle_seconds
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
 
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
  
   END INPUT
  
   CLOSE t323_b2cl
 
END FUNCTION
 
FUNCTION t323_b_fill()
    
 
   LET g_sql =  "SELECT cdk05,cdk11,cdk06,'',cdk13,'',cdk07,'',cdk08,cdk09 ",
                "  FROM cdk_file",
                " WHERE cdk01 ='",g_cdk_h.cdk01,"'",
                "   AND cdk02 ='",g_cdk_h.cdk02,"'",
                "   AND cdk03 ='",g_cdk_h.cdk03,"'",
                "   AND cdk04 ='",g_cdk_h.cdk04,"'",
                " ORDER BY 1,2,3,4"
    PREPARE t323_pb FROM g_sql
    DECLARE cdk_curs CURSOR FOR t323_pb
 
    CALL g_cdk.clear()
    LET g_cnt = 1
    FOREACH cdk_curs INTO g_cdk[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach.',STATUS,1) EXIT FOREACH END IF
       SELECT aag02 INTO g_cdk[g_cnt].aag02 FROM aag_file WHERE aag01 = g_cdk[g_cnt].cdk07 AND aag00 = g_cdk_h.cdk01
       SELECT aag02 INTO g_cdk[g_cnt].aag02_2 FROM aag_file WHERE aag01 = g_cdk[g_cnt].cdk13 AND aag00 = g_cdk_h.cdk01
       SELECT ima02 INTO g_cdk[g_cnt].ima02 FROM ima_file WHERE ima01 = g_cdk[g_cnt].cdk06 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_cdk.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION

FUNCTION t323_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)   
   CALL cl_show_fld_cont()

      DISPLAY ARRAY g_cdk TO s_cdk.*  ATTRIBUTE(COUNT=g_rec_b)         
      BEFORE DISPLAY
            CALL cl_show_fld_cont()
            CALL cl_navigator_setting( g_curs_index, g_row_count )
                        
         BEFORE ROW
         LET l_ac = ARR_CURR() 
         LET l_ac1 = l_ac
         CALL cl_show_fld_cont()      
         LET g_cdk_h.cdk05 = g_cdk[l_ac].cdk05
  
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t323_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION previous
         CALL t323_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION jump
         CALL t323_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION next
         CALL t323_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
 
      ON ACTION last
         CALL t323_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 

      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
                  
      ON ACTION gen_entry 
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
 
      ON ACTION entry_sheet  #分錄底稿
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"        #No.FUN-A60024
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE   #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         EXIT DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033

      ON ACTION CONTROLG
         CALL cl_cmdask()        # Command execution
                                                         
      ON ACTION drill_down1                                                      
         LET g_action_choice="drill_down1"                                       
         EXIT DISPLAY                                                           

      ON ACTION confirm #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
                   
      ON ACTION undo_confirm #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY 

      ON action process_qry 
         LET g_action_choice="process_qry"
         EXIT DISPLAY  

      ON action carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY  

      ON action undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY  

#No.FUN-CC0001 --begin
      ON action voucher_qry
         LET g_action_choice="voucher_qry"
         EXIT DISPLAY 
#No.FUN-CC0001 --end
                  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

 
FUNCTION t323_v()
DEFINE  l_wc        STRING
   IF g_cdk_h.cdkconf ='Y' THEN RETURN END IF 
   LET l_wc = "cdk01 ='",g_cdk_h.cdk01,"' AND cdk02 ='",g_cdk_h.cdk02,"' AND cdk03 ='",g_cdk_h.cdk03,"' AND cdk04 = '",g_cdk_h.cdk04,"'"
   LET g_success ='Y'
   CALL p323_gl(g_cdk_h.cdk04,g_cdk_h.cdk02,g_cdk_h.cdk03,g_cdk_h.cdk01)
   IF g_success ='N' THEN 
      RETURN  
   END IF 
   MESSAGE " "
END FUNCTION

                                                         
FUNCTION t323_drill_down()                                                      
   IF cl_null(l_ac1) THEN RETURN END IF                                                                              
   IF cl_null(g_cdk[l_ac1].cdk06) THEN RETURN END IF                                   
   LET g_msg = "aimq997 '",g_cdk[l_ac1].cdk06,"' '",g_cdk_h.cdk02,"' '",g_cdk_h.cdk03,"'"                                      
   CALL cl_cmdrun(g_msg)                                                        
END FUNCTION                                                                    

FUNCTION t323_count()
 
   DEFINE l_cdk   DYNAMIC ARRAY of RECORD        # 程式變數
          cdk01          LIKE cdk_file.cdk01, 
          cdk02          LIKE cdk_file.cdk02,          
          cdk03          LIKE cdk_file.cdk03,
          cdk04          LIKE cdk_file.cdk04                  
                     END RECORD
   DEFINE li_cnt         LIKE type_file.num10   #FUN-680135 INTEGER
   DEFINE li_rec_b       LIKE type_file.num10   #FUN-680135 INTEGER

   LET g_sql= "SELECT UNIQUE cdk01,cdk02,cdk03,cdk04 FROM cdk_file ",  #No.FUN-710055
              " WHERE ",g_wc CLIPPED 
   PREPARE t323_precount FROM g_sql
   DECLARE t323_count CURSOR FOR t323_precount
   LET li_cnt=1
   LET li_rec_b=0
   FOREACH t323_count INTO l_cdk[li_cnt].*  
       LET li_rec_b = li_rec_b + 1
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          LET li_rec_b = li_rec_b - 1
          EXIT FOREACH
       END IF
       LET li_cnt = li_cnt + 1
    END FOREACH
    LET g_row_count=li_rec_b 
END FUNCTION

FUNCTION t323_firm1_chk() 
DEFINE l_ccz12  LIKE ccz_file.ccz12 
DEFINE l_flg    LIKE type_file.chr1

    LET g_success ='Y'
#CHI-C30107 -------------------- add -------------------- begin
    IF g_cdk_h.cdkconf ='Y' THEN LET g_success ='N' RETURN END IF
    IF g_cdk_h.cdk01 IS NULL THEN LET g_success ='N' RETURN END IF
    IF NOT cl_confirm('aap-222') THEN
       LET g_success ='N'
       RETURN
    END IF
    SELECT * INTO g_cdk_h.* FROM cdk_file 
     WHERE cdk01 = g_cdk_h.cdk01
       AND cdk02 = g_cdk_h.cdk02
       AND cdk03 = g_cdk_h.cdk03
       AND cdk04 = g_cdk_h.cdk04
       AND cdk05 = g_cdk_h.cdk05
       AND cdk06 = g_cdk_h.cdk06
#CHI-C30107 -------------------- add -------------------- end
    IF g_cdk_h.cdkconf ='Y' THEN LET g_success ='N' RETURN END IF 
    IF g_cdk_h.cdk01 IS NULL THEN LET g_success ='N' RETURN END IF  
    SELECT ccz12 INTO l_ccz12 FROM ccz_file 
    IF g_cdk_h.cdk01 = l_ccz12 THEN 
       LET l_flg =0
    ELSE
       LET l_flg =1
    END IF  
    CALL s_chknpq(g_cdk_h.cdk10,'CA',1,l_flg,g_cdk_h.cdk01)    
END FUNCTION 

FUNCTION t323_firm1_upd()
#CHI-C30107 --------------- add ---------------- begin
#   IF NOT cl_confirm('aap-222') THEN
#      RETURN
#   END IF
#CHI-C30107 --------------- add ---------------- end
    LET g_cdk_h.cdkconf ='Y' 
    UPDATE cdk_file SET cdkconf ='Y' 
     WHERE cdk01 = g_cdk_h.cdk01
       AND cdk02 = g_cdk_h.cdk02
       AND cdk03 = g_cdk_h.cdk03
       AND cdk04 = g_cdk_h.cdk04
END FUNCTION 

FUNCTION t323_firm2()
   IF g_nppglno  IS NOT NULL THEN RETURN END IF  
   IF g_cdk_h.cdkconf ='N' THEN RETURN END IF
   IF NOT cl_confirm('aap-224') THEN
      RETURN
   END IF
    LET g_cdk_h.cdkconf ='N' 
    UPDATE cdk_file SET cdkconf ='N' 
     WHERE cdk01 = g_cdk_h.cdk01
       AND cdk02 = g_cdk_h.cdk02
       AND cdk03 = g_cdk_h.cdk03
       AND cdk04 = g_cdk_h.cdk04
   
END FUNCTION 

