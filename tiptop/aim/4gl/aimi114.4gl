# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: aimi114.4gl
# Desc/riptions..: 採購料件市價維護作業
# Date & Author..: 93/10/15 By fiona
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-510017 05/01/28 By Mandy 報表轉XML
# Modify.........: NO.MOD-590039 05/10/17 By Rosayu 單身刪除資料不會詢問
# Modify.........: No.TQC-630106 06/03/10 By Claire DISPLAY ARRAY無控制單身筆數
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-770006 07/07/30 By zhoufeng 報表打印改為Crystal Reports
# Modify.........: No.TQC-780080 07/11/05 By Pengu SQL使用OUTER未按照標準程序加上table.欄位
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-8A0068 09/02/19 By shiwuying 報表SQL修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0145 09/10/27 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-B20118 11/02/21 By destiny 隐藏串查按钮          
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
          tm  RECORD                          # Print condition RECORD
             wc      LIKE type_file.chr1000,  # Where condition  #No.FUN-690026 VARCHAR(300)
             bdate   LIKE type_file.dat,      #起始日期  #No.FUN-690026 DATE
             edate   LIKE type_file.dat       #截止日期  #No.FUN-690026 DATE
             END RECORD ,
    g_ima    DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables) 單身
             ima01   LIKE ima_file.ima01,    #料件編號
             ima02   LIKE ima_file.ima02,    #品名規格
             ima021  LIKE ima_file.ima021,   #品名規格
             descr   LIKE ze_file.ze03,      #購料特性  #No.FUN-690026 VARCHAR(04)
             ima44   LIKE ima_file.ima44,    #採購單位
             ima53   LIKE ima_file.ima53,    #採購單價
             imb218  LIKE imb_file.imb218,   #平均單價
             ima531  LIKE ima_file.ima531,   #市    價
             ima532  LIKE ima_file.ima532    #異動日期
             END RECORD,
    g_ima_o          RECORD                  #程式變數 (舊值)
             ima01   LIKE ima_file.ima01,    #料件編號
             ima02   LIKE ima_file.ima02,    #品名規格
             ima021  LIKE ima_file.ima021,   #品名規格
             descr   LIKE ze_file.ze03,      #購料特性  #No.FUN-690026 VARCHAR(04)
             ima44   LIKE ima_file.ima44,    #採購單位
             ima53   LIKE ima_file.ima53,    #採購單價
             imb218  LIKE imb_file.imb218,   #平均單價
             ima531  LIKE ima_file.ima531,   #市    價
             ima532  LIKE ima_file.ima532    #異動日期
             END RECORD,
#   m_azi03           LIKE azi_file.azi03,    #NO.CHI-6A0004
    g_ima_t            RECORD LIKE ima_file.*, #料件主檔資料
    g_wc,g_wc2,g_sql   string,                 #WHERE CONDITION      #No.FUN-580092 HCN
    g_rec_b            LIKE type_file.num5,    #單身筆數             #No.FUN-690026 SMALLINT
    l_ac               LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql    STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_str           STRING                  #No.FUN-770006
MAIN
#DEFINE                             #No.FUN-6A0074
#    l_time LIKE type_file.chr8   #計算被使用時間  #No.FUN-690026 VARCHAR(8)#No.FUN-6A0074
 
    OPTIONS                                    #改變一些系統預設值
        INPUT NO WRAP
        DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
#No.FUN-6A0074 -- begin --
#      CALL cl_used(g_prog,l_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818
#        RETURNING l_time
      CALL cl_used(g_prog,g_time,1)   RETURNING g_time
#No.FUN-6A0074 -- end --
       LET p_row = 3 LET p_col = 2
 
 
    OPEN WINDOW i114_w  AT p_row,p_col
        WITH FORM "aim/42f/aimi114" 
 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
#    IF cl_chk_act_auth() THEN
        CALL i114_q()
 
    CALL i114_menu()
 
       CLOSE WINDOW i114_w                 #結束畫面
#    END IF
#No.FUN-6A0074 -- begin --
#      CALL cl_used(g_prog,l_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818
#        RETURNING l_time
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
#No.FUN-6A0074 -- end --
END MAIN
 
#QBE 查詢資料
FUNCTION i114_cs()
DEFINE   l_cnt LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
   CLEAR FORM #清除畫面
   CALL g_ima.clear()
 
   #UI
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
       LET p_row = 4 LET p_col = 17
   ELSE
       LET p_row = 3 LET p_col = 15
   END IF
   OPEN WINDOW i114_w2 AT p_row,p_col #條件畫面
        WITH FORM "aim/42f/aimi1141" 
 
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aimi1141")
 
   CALL cl_opmsg('q')
   CONSTRUCT g_wc ON ima01,ima06,ima09,ima10,ima11,ima12,ima103,ima43,ima54
                FROM ima01,ima06,ima09,ima10,ima11,ima12,ima103,ima43,ima54 
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
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
   IF INT_FLAG THEN CLOSE WINDOW i114_w2 RETURN END IF
   INITIALIZE tm.* TO NULL   # Default condition
   INPUT BY NAME tm.bdate,tm.edate WITHOUT DEFAULTS 
 
      AFTER FIELD edate 
         IF tm.edate IS NOT NULL AND tm.bdate IS NOT NULL
           THEN IF tm.edate < tm.bdate  
                THEN NEXT FIELD bdate 
                END IF  
         END IF
 
      AFTER INPUT 
       IF INT_FLAG THEN EXIT INPUT END IF
 
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask() # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
   END INPUT
   IF INT_FLAG THEN CLOSE WINDOW i114_w2 RETURN END IF
 
   #No.TQC-9A0145  --Begin
  LET g_sql = " SELECT ima01,ima02,ima021,ima103,ima44,ima53,imb218,ima531,", 
              " ima532 ",
              " FROM ima_file LEFT OUTER JOIN imb_file ",
              "               ON ima_file.ima01 = imb_file.imb01",
              " WHERE ima08 IN ('P','V','Z') ",
              " AND ", g_wc CLIPPED
   #No.TQC-9A0145  --End
 
    IF NOT cl_null(tm.bdate) THEN 
       LET g_sql = g_sql CLIPPED," AND ima532 >='",tm.bdate,"'"
    END IF
    IF NOT cl_null(tm.edate) THEN 
       LET g_sql = g_sql CLIPPED," AND ima532 <='",tm.edate,"'"
    END IF
    LET g_sql = g_sql clipped," ORDER BY ima01 "
    PREPARE i114_prepare FROM g_sql
    DECLARE i114_cs                         
        CURSOR FOR i114_prepare
 
    #BugNo:5688
    LET g_sql="SELECT COUNT(ima01) FROM ima_file ",
              " WHERE ima08 IN ('P','V','Z') ",
              "   AND ", g_wc CLIPPED
    IF NOT cl_null(tm.bdate) THEN 
       LET g_sql = g_sql CLIPPED," AND ima532 >='",tm.bdate,"'"
    END IF
    IF NOT cl_null(tm.edate) THEN 
       LET g_sql = g_sql CLIPPED," AND ima532 <='",tm.edate,"'"
    END IF
    PREPARE i114_precount FROM g_sql
    DECLARE i114_count CURSOR FOR i114_precount
    CLOSE WINDOW i114_w2
END FUNCTION
 
#中文的MENU
FUNCTION i114_menu()
 
   WHILE TRUE
      CALL i114_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i114_q()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i114_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i114_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
#Query 查詢
FUNCTION i114_q()
  DEFINE l_cnt        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
         l_i          LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    MESSAGE ""
    CLEAR FORM
   CALL g_ima.clear()
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i114_cs()
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW i114_w  #結束畫面
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM
    END IF
    MESSAGE ' WAIT ' 
    OPEN i114_count
    FETCH i114_count INTO g_cnt
    DISPLAY g_cnt TO FORMONLY.cnt  
    LET g_cnt = 1
    FOR l_i = 1 TO g_ima.getLength() 
   INITIALIZE g_ima[l_i].* TO NULL
    END FOR
    FOREACH i114_cs INTO g_ima[g_cnt].*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        CALL s_purdesc(g_ima[g_cnt].descr) RETURNING g_ima[g_cnt].descr
        LET g_cnt = g_cnt + 1
        #TQC-630106-begin 
         IF g_cnt > g_max_rec THEN   #MOD-4B0274
            CALL cl_err( '', 9035, 0 )
            EXIT FOREACH
         END IF
        #TQC-630106-end 
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
#   CALL i114_bp("G")
    MESSAGE ''
END FUNCTION
# ff start
#單身
FUNCTION i114_b()
DEFINE
    l_imb218        LIKE imb_file.imb218,
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                #可新增否  #No.FUN-690026 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1                 #可刪除否  #No.FUN-690026 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
 
    #LET l_allow_insert = cl_detail_input_auth('insert') #MOD-590039 mark
    #LET l_allow_delete = cl_detail_input_auth('delete') #MOD-590039 mark
     LET l_allow_insert = FALSE #MOD-590039 add
     LET l_allow_delete = FALSE #MOD-590039 add
 
    CALL cl_opmsg('b')
 
    LET g_action_choice = ""
 
    LET g_forupd_sql = "SELECT ima01,ima02,ima021,ima103,ima44,ima53,0    ,ima531,ima532 FROM ima_file WHERE ima01= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i114_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_ima_o.* = g_ima[l_ac].*  #BACKUP
               OPEN i114_bcl USING g_ima_o.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i114_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH i114_bcl INTO g_ima[l_ac].* 
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_ima_o.ima01,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"     #單身鎖住  
               END IF
               SELECT imb218 INTO l_imb218 FROM imb_file 
                WHERE imb01 = g_ima[l_ac].ima01
               IF SQLCA.sqlcode THEN LET l_imb218 = ' ' END IF
               LET g_ima[l_ac].imb218 = l_imb218
               CALL s_purdesc(g_ima[l_ac].descr) 
                                RETURNING g_ima[l_ac].descr
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER FIELD ima531
            IF g_ima[l_ac].ima01 IS NOT NULL AND g_ima[l_ac].ima01 != ' ' THEN 
               IF g_ima[l_ac].ima531 IS NULL OR g_ima[l_ac].ima531 = ' '
                  OR g_ima[l_ac].ima531 < 0 THEN 
                  LET g_ima[l_ac].ima531 = g_ima_t.ima531 
                   NEXT FIELD ima531
               END IF
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ima[l_ac].* = g_ima_o.*
              CLOSE i114_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ima[l_ac].ima01,-263,1)
               LET g_ima[l_ac].* = g_ima_o.*
           ELSE
               UPDATE ima_file 
                  SET ima531 = g_ima[l_ac].ima531,
                      ima532 = g_sma.sma30,
                      imamodu = g_user,
                      imadate = g_today
                WHERE ima01 = g_ima[l_ac].ima01
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ima[l_ac].ima01,'mfg0151',0) #No.FUN-660156
                  CALL cl_err3("upd","ima_file",g_ima[l_ac].ima01,"",
                               "mfg0151","","",1)  #No.FUN-660156
                  LET g_ima[l_ac].* = g_ima_o.*
                  ROLLBACK WORK
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_ima[l_ac].* = g_ima_o.*
              END IF
              CLOSE i114_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac
           CLOSE i114_bcl
           COMMIT WORK
 
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
 
 
    CLOSE i114_bcl
    COMMIT WORK
END FUNCTION
   
FUNCTION i114_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
      #TQC-B20118--begin
      BEFORE DISPLAY 
        CALL cl_show_fld_cont()  
      #TQC-B20118--end     

      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
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
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i114_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD  
                    ima01   LIKE ima_file.ima01,    #料件編號
                    descr   LIKE ze_file.ze03,      #購料特性  #No.FUN-690026 VARCHAR(04)
                    ima44   LIKE ima_file.ima44,    #採購單位
                    ima53   LIKE ima_file.ima53,    #採購單價
                    ima531  LIKE ima_file.ima531,   #市    價
                    ima532  LIKE ima_file.ima532,   #異動日期
                    ima02   LIKE ima_file.ima02,    #品名規格
                    ima021  LIKE ima_file.ima021,   #品名規格
                    imb218  LIKE imb_file.imb218    #平均單價
                    END RECORD,
    l_name          LIKE type_file.chr20,           #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    descr           LIKE ze_file.ze03               #External(Disk) file name  #No.FUN-690026 VARCHAR(04)
 
    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
#   CALL cl_outnam('aimi114') RETURNING l_name                  #No.FUN-770006
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT ima01,ima103,ima44,ima53,ima531,ima532,ima02,ima021,imb218 ",
         " FROM ima_file LEFT OUTER JOIN imb_file ON ima_file.ima01 = imb_file.imb01 ",
         " WHERE ima08 IN ('P','V','Z') ",
              " AND ", g_wc CLIPPED
#   PREPARE i114_p1 FROM g_sql                # RUNTIME 編譯#No.FUN-770006
#   DECLARE i114_curo                         # CURSOR      #No.FUN-770006
#       CURSOR FOR i114_p1                                  #No.FUN-770006
 
#   START REPORT i114_rep TO l_name                         #No.FUN-770006
#NO.CHI-6A0004-BEGIN
#    SELECT azi03
#      INTO m_azi03
#      FROM azi_file
#      WHERE azi01 = g_aza.aza17               #本幣
#
#    IF SQLCA.SQLCODE THEN
#      LET m_azi03 = 0                       #NO.CHI-6A0004
#       LET g_azi03 = 0                       #NO.CHI-6A0004  
#    END IF
#NO.CHI-6A0004--END
#    IF cl_null(m_azi03) THEN LET m_azi03 =  0 END IF       #NO.CHI-6A0004 
     IF cl_null(g_azi03) THEN LET g_azi03 =  0 END IF       #NO.CHI-6A0004 
#No.FUN-770006 --start-- mark
#    FOREACH i114_curo INTO sr.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#            END IF
#        OUTPUT TO REPORT i114_rep(sr.*)
#    END FOREACH
 
#   FINISH REPORT i114_rep
 
#    CLOSE i114_curo
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-770006 --end--
#No.FUN-770006 --start--
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
    IF g_zz05 = 'Y' THEN
          CALL cl_wcchp(g_wc,'ima01,ima06,ima09,ima10,ima11,ima12,
                               ima103,ima43,ima54')
          RETURNING g_wc
          LET g_str = g_wc     
    END IF
    LET g_str = g_str,";",g_azi03
    CALL cl_prt_cs1('aimi114','aimi114',g_sql,g_str)
#No.FUN-770006 --end--
END FUNCTION
#No.FUN-770006 --start-- mark
{REPORT i114_rep(sr)
DEFINE
    l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    sr              RECORD 
                    ima01   LIKE ima_file.ima01,    #料件編號
                    descr   LIKE ze_file.ze03,      #購料特性  #No.FUN-690026 VARCHAR(04)
                    ima44   LIKE ima_file.ima44,    #採購單位
                    ima53   LIKE ima_file.ima53,    #採購單價
                    ima531  LIKE ima_file.ima531,   #市    價
                    ima532  LIKE ima_file.ima532,   #異動日期
                    ima02   LIKE ima_file.ima02,    #品名規格
                    ima021  LIKE ima_file.ima021,    #品名規格
                    imb218  LIKE imb_file.imb218     #平均單價
                    END RECORD,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima05         LIKE ima_file.ima05
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.ima01
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno" 
            PRINT g_head CLIPPED,pageno_total     
            PRINT 
            PRINT g_dash
            PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37]
            PRINTX name=H2 g_x[38]
            PRINTX name=H3 g_x[39]
            PRINT g_dash1 
            LET l_trailer_sw = 'n'
 
        ON EVERY ROW
            PRINTX name=D1 COLUMN g_c[31],sr.ima01,
                           COLUMN g_c[32],s_purdesc(sr.descr) CLIPPED,
                           COLUMN g_c[33],sr.ima44 CLIPPED,
#NO.CHI-6A0004-BEGIN
#                          COLUMN g_c[34],cl_numfor(sr.ima53,34,m_azi03) CLIPPED,
#                          COLUMN g_c[35],cl_numfor(sr.imb218,35,m_azi03) CLIPPED,
#                          COLUMN g_c[36],cl_numfor(sr.ima531,36,m_azi03) CLIPPED,
                           COLUMN g_c[34],cl_numfor(sr.ima53,34,g_azi03) CLIPPED, 
                           COLUMN g_c[35],cl_numfor(sr.imb218,35,g_azi03) CLIPPED,
                           COLUMN g_c[36],cl_numfor(sr.ima531,36,g_azi03) CLIPPED,
#NO.CHI-6A0004-END
                           COLUMN g_c[37],sr.ima532 
            PRINTX name=D2 COLUMN g_c[38],sr.ima02
            PRINTX name=D3 COLUMN g_c[39],sr.ima021
 
        ON LAST ROW
            PRINT g_dash
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'y'
        PAGE TRAILER
            IF l_trailer_sw = 'n' THEN
                PRINT g_dash
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
#No.FUN-770006 --end--
