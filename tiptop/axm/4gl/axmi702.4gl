# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: axmi702.4gl
# Descriptions...: 潛在客戶等級資料維護作業
# Date & Author..: 02/11/07 by Leagh
#
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改 
# Modify.........: No.MOD-5A0322 05/10/24 By Sarah 無法匯出至EXCEL
# Modify.........: No.FUN-660167 06/06/26 By day cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6A0091 06/11/07 By ice 修正報表格式錯誤
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-740317 07/04/26 By bnlent 添加報錯信息 
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_ofc           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        ofc01       LIKE ofc_file.ofc01,   
        ofc02       LIKE ofc_file.ofc02,  
        ofc03       LIKE ofc_file.ofc03,  
        ofc04       LIKE ofc_file.ofc04,  
        ofc05       LIKE ofc_file.ofc05,  
        ofc06       LIKE ofc_file.ofc06,  
        ofc07       LIKE ofc_file.ofc07,  
        ofc08       LIKE ofc_file.ofc08,  
        ofc09       LIKE ofc_file.ofc09,  
        ofc10       LIKE ofc_file.ofc10,  
        ofcacti     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
                    END RECORD,
    g_ofc_t         RECORD                 #程式變數 (舊值)
        ofc01       LIKE ofc_file.ofc01,   
        ofc02       LIKE ofc_file.ofc02,  
        ofc03       LIKE ofc_file.ofc03,  
        ofc04       LIKE ofc_file.ofc04,  
        ofc05       LIKE ofc_file.ofc05,  
        ofc06       LIKE ofc_file.ofc06,  
        ofc07       LIKE ofc_file.ofc07,  
        ofc08       LIKE ofc_file.ofc08,  
        ofc09       LIKE ofc_file.ofc09,  
        ofc10       LIKE ofc_file.ofc10,  
        ofcacti     LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1) 
                    END RECORD,
     g_wc2,g_sql    STRING, #No.FUN-580092 HCN  
    p_row,p_col     LIKE type_file.num5,   #No.FUN-680137 SMALLINT
    g_rec_b         LIKE type_file.num5,   #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5    #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL  
DEFINE g_before_input_done   STRING
 
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose   #No.FUN-680137 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS                                 #改變一些系統預設值 
        INPUT NO WRAP
    DEFER INTERRUPT                        #輸入的方式: 不打轉                           
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)  #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time                   #計算使用時間 (進入時間)                          #No.FUN-6A0094
    LET p_row = 3 LET p_col = 2 
    OPEN WINDOW i702_w AT p_row,p_col WITH FORM "axm/42f/axmi702"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i702_b_fill(g_wc2)
    CALL i702_menu()
    CLOSE WINDOW i702_w                  #結束畫面                      
      CALL  cl_used(g_prog,g_time,2)        #計算使用時間 (退出使間)     #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i702_menu()
 
   WHILE TRUE
      CALL i702_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i702_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i702_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i702_out() 
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ofc),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i702_q()
   CALL i702_b_askkey()
END FUNCTION
 
FUNCTION i702_b()
DEFINE
    l_ac_t          LIKE type_file.num5,               #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,               #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,               #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,               #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,               #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                #可刪除否          #No.FUN-680137 SMALLINT
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT ofc01,ofc02,ofc03,ofc04,ofc05,ofc06,ofc07,ofc08,ofc09,ofc10,ofcacti FROM ofc_file WHERE ofc01=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i702_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ofc WITHOUT DEFAULTS FROM s_ofc.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
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
               LET g_ofc_t.* = g_ofc[l_ac].*     
 
               BEGIN WORK
 
               OPEN i702_bcl USING g_ofc_t.ofc01
               IF STATUS THEN
                  CALL cl_err("OPEN i702_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i702_bcl INTO g_ofc[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ofc_t.ofc01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               LET g_before_input_done = FALSE                                   
               CALL i702_set_entry(p_cmd)                                        
               CALL i702_set_no_entry(p_cmd)                                     
               LET g_before_input_done = TRUE
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO ofc_file(ofc01,ofc02,ofc03,ofc04,
                                 ofc05,ofc06,ofc07,ofc08,
                                 ofc09,ofc10,ofcacti,
                                 ofcuser,ofcgrup,ofcdate,ofcoriu,ofcorig)
            VALUES(g_ofc[l_ac].ofc01,g_ofc[l_ac].ofc02,
                   g_ofc[l_ac].ofc03,g_ofc[l_ac].ofc04,
                   g_ofc[l_ac].ofc05,g_ofc[l_ac].ofc06,
                   g_ofc[l_ac].ofc07,g_ofc[l_ac].ofc08,
                   g_ofc[l_ac].ofc09,g_ofc[l_ac].ofc10,
                   g_ofc[l_ac].ofcacti,g_user,g_grup,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ofc[l_ac].ofc01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","ofc_file",g_ofc[l_ac].ofc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cnt2  
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ofc[l_ac].* TO NULL    
            LET g_ofc[l_ac].ofc03 = 'Y'  
            LET g_ofc[l_ac].ofc04 = 0
            LET g_ofc[l_ac].ofc05 = 0
            LET g_ofc[l_ac].ofc06 = 0
            LET g_ofc[l_ac].ofc07 = 'Y'     
            LET g_ofc[l_ac].ofc08 = 'Y'    
            LET g_ofc[l_ac].ofc09 = 'Y'   
            LET g_ofc[l_ac].ofc10 = 'Y'  
            LET g_ofc[l_ac].ofcacti = 'Y' 
            LET g_ofc_t.* = g_ofc[l_ac].*          #輸入新資料
            LET g_before_input_done = FALSE                                   
            CALL i702_set_entry(p_cmd)                                        
            CALL i702_set_no_entry(p_cmd)                                     
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ofc01
        
        AFTER FIELD ofc01                        #check 編號是否重複
            IF NOT cl_null(g_ofc[l_ac].ofc01) THEN
            IF g_ofc[l_ac].ofc01 != g_ofc_t.ofc01 OR
               (g_ofc[l_ac].ofc01 IS NOT NULL AND g_ofc_t.ofc01 IS NULL) THEN
                SELECT COUNT(*) INTO l_n FROM ofc_file
                    WHERE ofc01 = g_ofc[l_ac].ofc01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_ofc[l_ac].ofc01 = g_ofc_t.ofc01
                    NEXT FIELD ofc01
                END IF
            END IF
            END IF
 
        BEFORE FIELD ofc03
            CALL i702_set_entry(p_cmd)                                        
 
        AFTER FIELD ofc03 
            IF g_ofc[l_ac].ofc03 MATCHES '[YN]' THEN
            IF g_ofc[l_ac].ofc03 = 'N' THEN
               LET g_ofc[l_ac].ofc04 = 0
               LET g_ofc[l_ac].ofc05 = 0
               LET g_ofc[l_ac].ofc06 = 0
               DISPLAY g_ofc[l_ac].ofc04 TO s_ofc[l_ac].ofc04
               DISPLAY g_ofc[l_ac].ofc05 TO s_ofc[l_ac].ofc05
               DISPLAY g_ofc[l_ac].ofc06 TO s_ofc[l_ac].ofc06
            END IF
            END IF 
            CALL i702_set_no_entry(p_cmd)                                     
 
        AFTER FIELD ofc06 
            IF NOT cl_null(g_ofc[l_ac].ofc06) THEN
               IF g_ofc[l_ac].ofc06 <= 0 THEN
                  CALL cl_err(g_ofc[l_ac].ofc06,"axm4011",0)    #No.TQC-740317
                  NEXT FIELD ofc06
               END IF
            END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ofc_t.ofc01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM ofc_file WHERE ofc01 = g_ofc_t.ofc01
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ofc_t.ofc01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","ofc_file",g_ofc_t.ofc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
 
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cnt2  
                MESSAGE "Delete OK"
                CLOSE i702_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ofc[l_ac].* = g_ofc_t.*
               CLOSE i702_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ofc[l_ac].ofc01,-263,1)
               LET g_ofc[l_ac].* = g_ofc_t.*
            ELSE
               UPDATE ofc_file SET                                               
                      ofc01=g_ofc[l_ac].ofc01,ofc02=g_ofc[l_ac].ofc02,              
                      ofc03=g_ofc[l_ac].ofc03,ofc04=g_ofc[l_ac].ofc04,              
                      ofc05=g_ofc[l_ac].ofc05,ofc06=g_ofc[l_ac].ofc06,              
                      ofc07=g_ofc[l_ac].ofc07,ofc08=g_ofc[l_ac].ofc08,              
                      ofc09=g_ofc[l_ac].ofc09,ofc10=g_ofc[l_ac].ofc10,              
                      ofcacti=g_ofc[l_ac].ofcacti,ofcmodu=g_user,              
                      ofcdate=g_today              
               WHERE ofc01 = g_ofc_t.ofc01
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_ofc[l_ac].ofc01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","ofc_file",g_ofc_t.ofc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_ofc[l_ac].* = g_ofc_t.*
                   ROLLBACK WORK 
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i702_bcl
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ofc[l_ac].* = g_ofc_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_ofc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i702_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034 add
            CLOSE i702_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i702_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                       #沿用所有欄位
            IF INFIELD(ofc01) AND l_ac > 1 THEN
                LET g_ofc[l_ac].* = g_ofc[l_ac-1].*
                NEXT FIELD ofc01
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
 
    CLOSE i702_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i702_b_askkey()
    CLEAR FORM
    CALL g_ofc.clear()
    CONSTRUCT g_wc2 ON ofc01,ofc02,ofc03,ofc04,ofc05,ofc06,ofc07,
                       ofc08,ofc09,ofc10,ofcacti
            FROM s_ofc[1].ofc01,s_ofc[1].ofc02,s_ofc[1].ofc03,
                 s_ofc[1].ofc04,s_ofc[1].ofc05,s_ofc[1].ofc06,
                 s_ofc[1].ofc07,s_ofc[1].ofc08,s_ofc[1].ofc09,
                 s_ofc[1].ofc10,s_ofc[1].ofcacti
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ofcuser', 'ofcgrup') #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i702_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i702_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(300)
 
    LET g_sql =
        "SELECT ofc01,ofc02,ofc03,ofc04,ofc05,ofc06,ofc07,ofc08,",
        "       ofc09,ofc10,ofcacti",
        "  FROM ofc_file",
        " WHERE ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i702_pb FROM g_sql
    DECLARE ofc_curs CURSOR FOR i702_pb
 
    CALL g_ofc.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH ofc_curs INTO g_ofc[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_ofc.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt2  
    LET g_cnt = 0
    
END FUNCTION
 
FUNCTION i702_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ofc TO s_ofc.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
   
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY    #MOD-5A0322
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#No.FUN-7C0043--start--
FUNCTION i702_out()
    DEFINE
        l_ofc           RECORD LIKE ofc_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE ima_file.ima01           #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
                                                                                                                                    
    IF g_wc2 IS NULL THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
    RETURN END IF                                                                                                                   
    LET l_cmd = 'p_query "axmi702" "',g_wc2 CLIPPED,'"'                                                                             
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN           
#   IF g_wc2 IS NULL THEN 
#      CALL cl_err('','9057',0)
#   RETURN END IF
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   LET g_sql="SELECT * FROM ofc_file ",         
#             " WHERE ",g_wc2 CLIPPED
#   PREPARE i702_p1 FROM g_sql                # RUNTIME 
#   DECLARE i702_co                           # CURSOR
#       CURSOR FOR i702_p1
 
#   LET g_rlang = g_lang                               #FUN-4C0096 add
#   CALL cl_outnam('axmi702') RETURNING l_name
#   START REPORT i702_rep TO l_name
 
#   FOREACH i702_co INTO l_ofc.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)  
#           EXIT FOREACH
#           END IF
#       OUTPUT TO REPORT i702_rep(l_ofc.*)
#   END FOREACH
 
#   FINISH REPORT i702_rep
 
#   CLOSE i702_co
#   ERROR ""
#   CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
#REPORT i702_rep(sr)
#  DEFINE
#      l_trailer_sw   LIKE type_file.chr1,           #No.FUN-680137 VARCHAR(1) 
#      sr RECORD LIKE ofc_file.*
 
#  OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
 
#   ORDER BY sr.ofc01
 
#   FORMAT
#       PAGE HEADER
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#           PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1] CLIPPED))/2)+1,g_x[1] CLIPPED   #No.TQC-6A0091
#           LET g_pageno = g_pageno + 1
#           LET pageno_total = PAGENO USING '<<<','/pageno'
#           PRINT g_head CLIPPED, pageno_total
#           #PRINT ''   #No.TQC-6A0091
 
#           PRINT g_dash
#           PRINT g_x[31], 
#                 g_x[32],
#                 g_x[33],
#                 g_x[34],
#                 g_x[35],
#                 g_x[36],
#                 g_x[37],
#                 g_x[38],
#                 g_x[39],
#                 g_x[40],
#                 g_x[41] 
#           PRINT g_dash1
#           LET l_trailer_sw = 'y'
 
#       ON EVERY ROW
#          PRINT COLUMN g_c[31],sr.ofc01,
#                COLUMN g_c[32],sr.ofc02,
#                COLUMN g_c[33],sr.ofc03,
#                COLUMN g_c[34],sr.ofc04 USING '###&',
#                COLUMN g_c[35],sr.ofc05 USING '###&',
#                COLUMN g_c[36],sr.ofc06 USING '###&',
#                COLUMN g_c[37],sr.ofc07,
#                COLUMN g_c[38],sr.ofc08,
#                COLUMN g_c[39],sr.ofc09,
#                COLUMN g_c[40],sr.ofc10,
#                COLUMN g_c[41],sr.ofcacti
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4] CLIPPED,
#                 COLUMN g_len-9, g_x[7] CLIPPED    #No.TQC-6A0091
#           LET l_trailer_sw = 'n'
#       PAGE TRAILER
#           IF l_trailer_sw = 'y' THEN
#               PRINT g_dash
#               PRINT g_x[4] CLIPPED,
#                     COLUMN g_len-9, g_x[6] CLIPPED    #No.TQC-6A0091
#           ELSE
#               SKIP 2 LINE
#           END IF
#END REPORT
#No.FUN-7C0043--end-- 
FUNCTION i702_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                  #No.FUN-680137 VARCHAR(1)
                                                                                
    IF INFIELD(ofc03) OR ( NOT g_before_input_done ) THEN                       
       CALL cl_set_comp_entry("ofc04,ofc05,ofc06",TRUE)
    END IF                                                                      
#No.FUN-570109 --start--                                                                                                            
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                             
       CALL cl_set_comp_entry("ofc01",TRUE)                                                                                         
    END IF                                                                                                                          
#No.FUN-570109 --end--                                                                                 
END FUNCTION                                                                    
                                                                                
FUNCTION i702_set_no_entry(p_cmd)                   
DEFINE p_cmd   LIKE type_file.chr1                     #No.FUN-680137 VARCHAR(1)
                                                                                
    IF INFIELD(ofc03) OR ( NOT g_before_input_done ) THEN                       
       IF g_ofc[l_ac].ofc03 = 'N' THEN
          CALL cl_set_comp_entry("ofc04,ofc05,ofc06",FALSE)
       END IF
    END IF  
#No.FUN-570109 --start--                                                                                                            
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                             
      CALL cl_set_comp_entry("ofc01",FALSE)                                                                                         
    END IF                                                                                                                          
#No.FUN-570109 --end--                                                                                                              
                                                                                                          
END FUNCTION            
 
