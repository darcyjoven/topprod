# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apsi332.4gl
# Descriptions...: APS保修明細維護作業
# Input parameter:
# Date & Author..: 08/09/24 By Duke No.FUN-880102 
# Modify.........: FUN-8A0069 08/10/15 by duke add strtime vnn021 and endtime vnn031 
# Modify.........: TQC-8A0067 08/10/24 by duke check 分<60, 秒<60
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_feb           RECORD LIKE feb_file.*,   #製程資料
    g_feb_t         RECORD LIKE feb_file.*,
    g_feb02_t       LIKE feb_file.feb02,
    g_type          LIKE type_file.chr1,     
    g_vnn          DYNAMIC ARRAY OF RECORD  #程式變數(Program Variables)
        vnn02      LIKE vnn_file.vnn02,    
        vnn021     LIKE vnn_file.vnn021,  #FUN-8A0069  add
        vnn03      LIKE vnn_file.vnn03,
        vnn031     LIKE vnn_file.vnn031   #FUN-8A0069  add     
                    END RECORD,
   g_vnn_t         RECORD  
        vnn02      LIKE vnn_file.vnn02,    
        vnn021     LIKE vnn_file.vnn021,  #FUN-8A0069 add
        vnn03      LIKE vnn_file.vnn03,
        vnn031     LIKE vnn_file.vnn031   #FUN-8A0069 add    
                    END RECORD,
    g_wc,g_sql          STRING,      
    g_wc2               STRING,     
    g_argv1         LIKE feb_file.feb02,   #工模具編號
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680073 SMALLINT
    p_row,p_col     LIKE type_file.num5,          
    l_ac            LIKE type_file.num5                #目前處理的ARRAY CNT        #No.FUN-680073 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL        
DEFINE g_before_input_done  LIKE type_file.num5          
 
DEFINE   g_cnt          LIKE type_file.num10         
DEFINE   g_i            LIKE type_file.num5          
DEFINE   g_msg          LIKE type_file.chr1000       
DEFINE   g_row_count    LIKE type_file.num10         
DEFINE   g_curs_index   LIKE type_file.num10         
DEFINE   g_jump         LIKE type_file.num10         
DEFINE   mi_no_ask      LIKE type_file.num5      
DEFINE   l_eci01        LIKE eci_file.eci01    
DEFINE   l_sma917        LIKE sma_file.sma917    #FUN-890012
DEFINE l_table        STRING,                                                   
       g_str          STRING,                                                   
       l_sql          STRING                                                    
 
MAIN
# DEFINE
#       l_time    LIKE type_file.chr8            
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APS")) THEN  #No.FUN-880102
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    
 
   
   LET g_argv1 =ARG_VAL(1)              #工模具編號
   LET g_feb02_t = NULL
   LET g_feb.feb02 =g_argv1              #工模具編號
 
   LET p_row = 5 LET p_col = 30
   OPEN WINDOW i332_w AT p_row,p_col
        WITH FORM "aps/42f/apsi332"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
 
   IF g_argv1 IS NOT NULL AND g_argv1 != ' ' THEN
      CALL i332_q()
      CALL i332_menu()
    ELSE
      LET g_type = '1'
      CALL i332_menu()
    END IF
 
    CLOSE WINDOW i332_w                 #結束畫面
 
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0100
         RETURNING g_time    #No.FUN-6A0100
 
END MAIN
 
#QBE 查詢資料
FUNCTION i332_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
   CALL g_vnn.clear()
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  
 THEN
    CALL cl_set_head_visible("","YES")    
 
    INITIALIZE g_feb.feb02 TO NULL        
   INITIALIZE g_feb.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
              feb02
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(feb02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.state    = "c"
                   LET g_qryparam.form = "q_vnn01"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO feb02
                   NEXT FIELD feb02
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
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 ELSE DISPLAY BY NAME g_feb.feb02
      LET g_wc = "  feb02 = '",g_feb.feb02,"' "
 END IF
    IF INT_FLAG THEN RETURN END IF
 
 IF g_argv1 IS NULL OR g_argv1 = ' '  
 THEN
   CONSTRUCT g_wc2 ON vnn02                 # 螢幕上取單身條件
            FROM s_vnn[1].vnn02
      BEFORE CONSTRUCT
         CALL cl_qbe_display_condition(lc_qbe_sn)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
   END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 ELSE LET g_wc2 = " 1=1"
 END IF
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT feb02 FROM feb_file ",
                   " WHERE ", g_wc CLIPPED
     ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT feb02 FROM feb_file ",
                   "  FROM feb_file, vnn_file ",
                   " WHERE feb02 = vnn01 ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i332_prepare FROM g_sql
    DECLARE i332_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i332_prepare
 
    LET g_forupd_sql = "SELECT * FROM feb_file ",
                       "WHERE feb02 = ?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i332_cl CURSOR FROM g_forupd_sql
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM feb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM feb_file,vnn_file WHERE ",
                  " feb02 = vnn01  ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
 
    PREPARE i332_precount FROM g_sql
    DECLARE i332_count CURSOR FOR i332_precount
 
END FUNCTION
 
FUNCTION i332_menu()
 
   WHILE TRUE
      CALL i332_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i332_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i332_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0012
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_vnn),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION i332_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_vnn.clear()
    CALL i332_cs()                         #取得查詢條件
    IF INT_FLAG THEN                       #使用者不玩了
        LET INT_FLAG = 0
        RETURN
    END IF
    OPEN i332_cs                           #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN                  #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_feb.feb02 TO NULL
    ELSE
        CALL i332_fetch('F')               #讀出TEMP第一筆並顯示
        OPEN i332_count
        FETCH i332_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i332_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680073 VARCHAR(1) VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680073 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i332_cs INTO g_feb.feb02
        WHEN 'P' FETCH PREVIOUS i332_cs INTO g_feb.feb02
        WHEN 'F' FETCH FIRST    i332_cs INTO g_feb.feb02
        WHEN 'L' FETCH LAST     i332_cs INTO g_feb.feb02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                   ON ACTION about         #MOD-4C0121
                      CALL cl_about()      #MOD-4C0121
 
                   ON ACTION help          #MOD-4C0121
                      CALL cl_show_help()  #MOD-4C0121
 
                   ON ACTION controlg      #MOD-4C0121
                      CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i332_cs INTO g_feb.feb02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_feb.feb01,SQLCA.sqlcode,0)
        INITIALIZE g_feb.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_feb.* FROM feb_file WHERE feb02 = g_feb.feb02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","feb_file",g_feb.feb02,"",SQLCA.sqlcode,"","",1) 
        INITIALIZE g_feb.* TO NULL
        RETURN
#FUN-4C0034
    ELSE
        CALL i332_show()
    END IF
##
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i332_show()
    LET g_feb_t.* = g_feb.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
        g_feb.feb02
 
    CALL i332_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   
END FUNCTION
#單身
FUNCTION i332_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT        #No.FUN-680073 SMALLINT SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680073 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680073 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態        #No.FUN-680073 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否        #No.FUN-680073 SMALLINT
    l_allow_delete  LIKE type_file.num5,     #可刪除否        #No.FUN-680073 SMALLINT
    l_sma917        LIKE sma_file.sma917    #FUN-890012
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
 
    IF  cl_null(g_feb.feb02) THEN
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT vnn02,vnn021,vnn03,vnn031 FROM vnn_file ", #FUN-8A0069  add vnn021,vnn031
                       " WHERE vnn01=? AND vnn02=? AND vnn021=?  FOR UPDATE"   #FUN-8A0069 add vnn021
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i332_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_vnn WITHOUT DEFAULTS FROM s_vnn.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN i332_cl USING g_feb.feb02
            IF STATUS THEN
               CALL cl_err("OPEN i332_cl_b:", STATUS, 1)
               CLOSE i332_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH i332_cl INTO g_feb.*   # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err('Fetch i332_cl_b',SQLCA.sqlcode,1)
               CLOSE i332_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_vnn_t.* = g_vnn[l_ac].*  #BACKUP
 
               OPEN i332_bcl USING g_feb.feb02,g_vnn_t.vnn02,g_vnn_t.vnn021 #FUN-8A0069 add g_vnn_t.vnn021
 
               IF STATUS THEN
                  CALL cl_err("OPEN i332_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i332_bcl INTO g_vnn[l_ac].*
                  IF SQLCA.sqlcode THEN
                      CALL cl_err('Fetch i332_bcl',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                  ELSE
                      LET g_vnn_t.*=g_vnn[l_ac].*
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_vnn[l_ac].* TO NULL      #900423
            LET g_vnn_t.* = g_vnn[l_ac].*                  #新輸入資料
            CALL cl_show_fld_cont()     
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 
            INSERT INTO vnn_file(vnn01,vnn02,vnn03,vnn021,vnn031)  #FUN-8A0069 add vnn021,vnn031
                           VALUES(g_feb.feb02,
                                  g_vnn[l_ac].vnn02,g_vnn[l_ac].vnn03,g_vnn[l_ac].vnn021,g_vnn[l_ac].vnn031)
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","vnn_file",g_feb.feb02,"",SQLCA.sqlcode,"","",1) #FUN-660091
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD vnn03
            IF NOT cl_null(g_vnn[l_ac].vnn03) THEN
               IF g_vnn[l_ac].vnn02>g_vnn[l_ac].vnn03 THEN
                  CALL cl_err('','ams-820',1)
                  NEXT FIELD vnn03
               END IF
            END IF
        AFTER FIELD vnn02
            IF NOT cl_null(g_vnn[l_ac].vnn03) THEN
               IF g_vnn[l_ac].vnn02>g_vnn[l_ac].vnn03 THEN
                  CALL cl_err('','ams-820',1)
                  NEXT FIELD vnn02
               END IF
            END IF
 
       #FUN-8A0069 ADD
       AFTER FIELD vnn021
           IF cl_null(g_vnn[l_ac].vnn02) THEN NEXT FIELD vnn021 END IF
           IF g_vnn[l_ac].vnn021[1,2]<'00' OR g_vnn[l_ac].vnn021[1,2]>'24' OR 
              g_vnn[l_ac].vnn021[4,5]<'00' OR g_vnn[l_ac].vnn021[4,5]>='60' OR  #TQC-8A0067
              g_vnn[l_ac].vnn021[3,3]!=':' OR length(g_vnn[l_ac].vnn021) != 5 OR
              (g_vnn[l_ac].vnn021[1,2]='24' ) THEN #TQC-8A0076 add
              CALL cl_err('','aem-006',0)
              NEXT FIELD vnn021
           END IF
           IF g_vnn[l_ac].vnn02=g_vnn[l_ac].vnn03 AND
              g_vnn[l_ac].vnn021 > g_vnn[l_ac].vnn031 THEN
              CALL cl_err('','asr-002',0)
              NEXT FIELD vnn021
           END IF
 
       #FUN-8A0069 ADD
       AFTER FIELD vnn031
           IF cl_null(g_vnn[l_ac].vnn03) AND NOT cl_null(g_vnn[l_ac].vnn031) THEN
              NEXT FIELD vnn031
           END IF
           IF NOT cl_null(g_vnn[l_ac].vnn03) AND cl_null(g_vnn[l_ac].vnn031) THEN
              NEXT FIELD vnn031
           END IF
           IF NOT cl_null(g_vnn[l_ac].vnn031) THEN
             IF g_vnn[l_ac].vnn031[1,2]<'00' OR g_vnn[l_ac].vnn031[1,2]>'24' OR
                g_vnn[l_ac].vnn031[4,5]<'00' OR g_vnn[l_ac].vnn031[4,5]>='60' OR   #TQC-8A0067
                g_vnn[l_ac].vnn031[3,3]!=':' OR length(g_vnn[l_ac].vnn031) != 5 OR
                (g_vnn[l_ac].vnn031[1,2]='24' ) THEN
                CALL cl_err('','aem-006',0)
                NEXT FIELD vnn031
             END IF
           END IF
           IF g_vnn[l_ac].vnn02=g_vnn[l_ac].vnn03 AND
              g_vnn[l_ac].vnn021 > g_vnn[l_ac].vnn031 THEN
              CALL cl_err('','asr-002',0)
              NEXT FIELD vnn031
           END IF
 
 
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_vnn_t.vnn02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) then
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM vnn_file
                 WHERE vnn01 = g_feb.feb02 
                   AND vnn02 = g_vnn_t.vnn02
                   AND vnn021 = g_vnn_t.vnn021  #FUN-8A0069 ADD
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","vnn_file",g_feb.feb02,"",SQLCA.sqlcode,"","",1) #FUN-660091
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
 
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
             END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_vnn[l_ac].* = g_vnn_t.*
               CLOSE i332_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_vnn[l_ac].vnn02,-263,1)
               LET g_vnn[l_ac].* = g_vnn_t.*
            ELSE
               #FUN-890012 add vms07∼vms13
               UPDATE vnn_file SET vnn02=g_vnn[l_ac].vnn02,
                                    vnn03=g_vnn[l_ac].vnn03,
                                    vnn021=g_vnn[l_ac].vnn021,  #FUN-8A0069 ADD
                                    vnn031=g_vnn[l_ac].vnn031   #FUN-8A0069 ADD
                WHERE vnn01= g_feb.feb02 AND
                      vnn02= g_vnn_t.vnn02  AND
                      vnn021=g_vnn_t.vnn021  #FUN-8A0069 ADD
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","vnn_file",g_feb.feb02,g_vnn_t.vnn02,SQLCA.sqlcode,"","",1)
                   LET g_vnn[l_ac].* = g_vnn_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_vnn[l_ac].* = g_vnn_t.*
               END IF
               CLOSE i332_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE i332_bcl
            COMMIT WORK
 
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(vnn02) AND l_ac > 1 THEN
                LET g_vnn[l_ac].* = g_vnn[l_ac-1].*
                DISPLAY g_vnn[l_ac].* TO s_vnn[l_ac].*
                NEXT FIELD vnn02
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
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
    CLOSE i332_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i332_b_askkey()
DEFINE
    l_wc       LIKE type_file.chr1000           #No.FUN-680073 VARCHAR(200)
 
    CONSTRUCT l_wc ON vnn02,vnn021,vnn03,vnn031             #螢幕上取條件 #FUN-8A0069 add vnn021,vnn031
       FROM s_vnn[1].vnn02,s_vnn[1].vnn021,s_vnn[1].vnn03,s_vnn[1].vnn031
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      #FUN-8A0069 ADD
      AFTER FIELD vnn021
         IF g_vnn[l_ac].vnn021[1,2]<'00' OR g_vnn[l_ac].vnn021[1,2]>'24' OR
            g_vnn[l_ac].vnn021[4,5]<'00' OR g_vnn[l_ac].vnn021[4,5]>='60' OR  #TQC-8A0067
            g_vnn[l_ac].vnn021[3,3]!=':' OR length(g_vnn[l_ac].vnn021) != 5 OR 
            (g_vnn[l_ac].vnn021[1,2]='24' ) THEN
            CALL cl_err('','aem-006',0)
            NEXT FIELD vnn021
         END IF
 
 
      #FUN-8A0069 ADD
      AFTER FIELD vnn031
         IF NOT cl_null(g_vnn[l_ac].vnn031) THEN
            IF g_vnn[l_ac].vnn031[1,2]<'00' OR g_vnn[l_ac].vnn031[1,2]>'24' OR
               g_vnn[l_ac].vnn031[4,5]<'00' OR g_vnn[l_ac].vnn031[4,5]>='60' OR #TQC-8A0067
               g_vnn[l_ac].vnn031[3,3]!=':' OR length(g_vnn[l_ac].vnn031) != 5 OR
               (g_vnn[l_ac].vnn031[1,2]='24' ) THEN
               CALL cl_err('','aem-006',0)
               NEXT FIELD vnn031
            END IF
         END IF
 
 
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    CALL i332_b_fill(l_wc)
END FUNCTION
 
FUNCTION i332_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,  #No.FUN-680073 VARCHAR(300)
    l_flag          LIKE type_file.chr1      #No.FUN-680073 VARCHAR(1)
 
    LET g_sql =
        "SELECT vnn02,vnn021,vnn03,vnn031 FROM vnn_file ", #FUN-8A0069  add vnn021,vnn031
        "  WHERE  vnn01 = '",g_feb.feb02,"'",
        "  AND ", p_wc2 CLIPPED            #單身
    PREPARE i332_pb FROM g_sql
    DECLARE vms_cs CURSOR FOR i332_pb            #SCROLL CURSOR
 
    CALL g_vnn.clear()
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH vms_cs INTO g_vnn[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_vnn.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i332_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680073 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_vnn TO s_vnn.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
 
      ON ACTION first
         CALL i332_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i332_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i332_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i332_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i332_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
#FUN-4B0012
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#No.FUN-760085---End
#Patch....NO.TQC-610035 <> #
