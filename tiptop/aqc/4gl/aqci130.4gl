# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: imai130.4gl
# Descriptions...: 料件檢驗條件設定作業
# Date & Author..: 99/08/08 by Mandy
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.MOD-590020 05/10/19 By Nicola 將單身的新增和刪除功能抑制掉
# Modify.........: No.FUN-640212 06/04/25 By Sarah 增加顯示材料類別(ima109)與檢驗否(ima24)兩個欄位
# Modify.........: No.FUN-660115 06/06/16 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680104 06/08/26 By Czl  類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-6C0127 06/12/25 By pengu COMBOBOX"級數"欄位的選項改由程式動態設定
# Modify.........: No.MOD-770135 07/07/28 By pengu [材料類別]開窗後帶入資料直接按確認無法UPDATE
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A80063 10/08/13 By wujie    添加aqci130中ima101和ima102的item
# Modify.........: No:MOD-A30105 10/03/16 By Pengu set entry未控管好
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_ima           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,    #料件編號
        ima02       LIKE ima_file.ima02,    #品名規格
        ima021      LIKE ima_file.ima021,   #規格
        ima08       LIKE ima_file.ima08,    #來源碼
        ima109      LIKE ima_file.ima109,   #材料類別   #FUN-640212 add
        ima24       LIKE ima_file.ima24,    #檢驗碼     #FUN-640212 add
        ima100      LIKE ima_file.ima100,   #檢驗程度
        ima101      LIKE ima_file.ima101,   #檢驗水準
        ima102      LIKE ima_file.ima102    #級數
                    END RECORD,
    g_ima_t         RECORD                  #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,    #料件編號
        ima02       LIKE ima_file.ima02,    #品名規格
        ima021      LIKE ima_file.ima021,   #規格
        ima08       LIKE ima_file.ima08,    #來源碼
        ima109      LIKE ima_file.ima109,   #材料類別   #FUN-640212 add
        ima24       LIKE ima_file.ima24,    #檢驗碼     #FUN-640212 add
        ima100      LIKE ima_file.ima100,   #檢驗程度
        ima101      LIKE ima_file.ima101,   #檢驗水準
        ima102      LIKE ima_file.ima102    #級數
                    END RECORD,
    g_wc,g_sql      STRING,                 #No.FUN-580092 HCN        #No.FUN-680104
    g_rec_b         LIKE type_file.num5,    #單身筆數        #No.FUN-680104 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT        #No.FUN-680104 SMALLINT
 
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL        #No.FUN-680104
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-680104 INTEGER
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680104 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("AQC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i130_w AT p_row,p_col WITH FORM "aqc/42f/aqci130"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_wc = ' 1=1'
    CALL i130_b_fill(g_wc)
    CALL i130_menu()
    CLOSE WINDOW i130_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
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
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i130_q()
    CALL i130_b_askkey()
END FUNCTION
 
FUNCTION i130_b()
DEFINE
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT #No.FUN-680104 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用    #No.FUN-680104 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否    #No.FUN-680104 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態      #No.FUN-680104 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,       #No.FUN-680104 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1        #No.FUN-680104 VARCHAR(1)
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
         "SELECT ima01,ima02,ima021,ima08,ima109,ima24,ima100,ima101,ima102 ",   #FUN-640212 add ima109,ima24
         "  FROM ima_file WHERE ima01 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i130_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
          INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)  #No.MOD-590020
        # INSERT ROW = l_allow_insert,
        # DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
               LET p_cmd='u'
               BEGIN WORK
               OPEN i130_bcl USING g_ima_t.ima01
               IF STATUS THEN
                  CALL cl_err("OPEN i130_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH i130_bcl INTO g_ima[l_ac].*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_ima_t.ima01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #start FUN-640212 add
            CALL i130_set_entry(p_cmd)
            CALL i130_set_no_entry(p_cmd)    #No:MOD-A30105 add
            CALL i130_set_no_required()
           #end FUN-640212 add
 
       BEFORE FIELD ima101
           IF g_ima[l_ac].ima01 IS NOT NULL THEN
              IF g_ima[l_ac].ima100 NOT MATCHES '[NTR]'
	          OR cl_null(g_ima[l_ac].ima100) THEN
	              NEXT FIELD ima100
	      END IF
           END IF
 
       AFTER FIELD ima101
           IF g_ima[l_ac].ima24 = 'Y' THEN   #FUN-640212 add
              IF g_ima[l_ac].ima101 NOT MATCHES '[1234]' THEN    #No.FUN-A80063
                 NEXT FIELD ima101
	      END IF
	   END IF                            #FUN-640212 add
#No.FUN-A80063 --begin
     IF g_ima_t.ima101 IS NULL OR g_ima_t.ima101 <> g_ima[l_ac].ima101 THEN 
        IF g_ima[l_ac].ima102 MATCHES '[567]' AND g_ima[l_ac].ima101 MATCHES '[12]' THEN 
           CALL cl_err('','aqc-045',1)
           LET g_ima[l_ac].ima101 = g_ima_t.ima101
           NEXT FIELD ima101
        END IF 
     END IF 
#No.FUN-A80063 --end
 
      #--------------No.MOD-6C0127 add
       BEFORE FIELD ima102
         CALL i130_combo()
      #--------------No.MOD-6C0127 end
 
       AFTER FIELD ima102
           IF g_ima[l_ac].ima24 = 'Y' THEN   #FUN-640212 add
              IF g_ima[l_ac].ima102 IS NOT NULL THEN
                IF g_ima[l_ac].ima101 = '1' THEN
                    IF g_ima[l_ac].ima102 NOT MATCHES '[123]' THEN
	                NEXT FIELD ima102
                    END IF
                ELSE
                    IF g_ima[l_ac].ima101 = '2' THEN
                        IF g_ima[l_ac].ima102 NOT MATCHES '[1234]' THEN
	                    NEXT FIELD ima102
                        END IF
                    END IF
#No.FUN-A80063 --begin
                    IF g_ima[l_ac].ima101 = '3' OR g_ima[l_ac].ima101 ='4' THEN
                        IF g_ima[l_ac].ima102 NOT MATCHES '[1234567]' THEN
	                    NEXT FIELD ima102
                        END IF
                    END IF
#No.FUN-A80063 --end
	        END IF
              END IF
	   END IF                            #FUN-640212 add
 
      #start FUN-640212 add
       AFTER FIELD ima109
           IF NOT cl_null(g_ima[l_ac].ima109) THEN
              IF (g_ima_t.ima109 IS NULL) OR (g_ima[l_ac].ima109 != g_ima_t.ima109) THEN
                 SELECT azf01 FROM azf_file
                  WHERE azf01=g_ima[l_ac].ima109 AND azf02='8' AND azfacti='Y'
                 IF SQLCA.sqlcode  THEN
#                   CALL cl_err(g_ima[l_ac].ima109,'mfg1306',0)   #No.FUN-660115
                    CALL cl_err3("sel","azf_file",g_ima[l_ac].ima109,"","mfg1306","","",1)  #No.FUN-660115
                    LET g_ima[l_ac].ima109 = g_ima_t.ima109
                   #--------------No.MOD-770135 modify
                   #DISPLAY g_ima[l_ac].ima109 TO FROMONLY.ima109
                    DISPLAY g_ima[l_ac].ima109 TO ima109
                   #--------------No.MOD-770135 end
                    NEXT FIELD ima109
                 END IF
              END IF
           END IF
 
      #-----------No:MOD-A30105 modify
      #AFTER FIELD ima24  #檢驗否
       ON CHANGE ima24  #檢驗否
      #-----------No:MOD-A30105 end
           IF NOT cl_null(g_ima[l_ac].ima24) THEN
              IF g_ima[l_ac].ima24 not matches '[YN]' THEN
                 NEXT FIELD ima24
              END IF
              IF g_ima[l_ac].ima24 = 'N' THEN
                 LET g_ima[l_ac].ima100 = '' 
                 LET g_ima[l_ac].ima101 = '' 
                 LET g_ima[l_ac].ima102 = ''
                 DISPLAY g_ima[l_ac].ima100 TO FORMONLY.ima100 
                 DISPLAY g_ima[l_ac].ima101 TO FORMONLY.ima101 
                 DISPLAY g_ima[l_ac].ima102 TO FORMONLY.ima102 
                #CALL i130_set_no_entry(p_cmd)          #MOD-A30105 mark
              ELSE
                 CALL i130_set_required()
              END IF
              CALL i130_set_entry(p_cmd)             #MOD-A30105 add 
              CALL i130_set_no_entry(p_cmd)          #MOD-A30105 add 
           END IF
      #end FUN-640212 add
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ima[l_ac].* = g_ima_t.*
            CLOSE i130_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_ima[l_ac].ima01,-263,1)
             LET g_ima[l_ac].* = g_ima_t.*
         ELSE
             UPDATE ima_file SET ima100=g_ima[l_ac].ima100,
                                 ima101=g_ima[l_ac].ima101,
                                 ima102=g_ima[l_ac].ima102,
                                 ima109=g_ima[l_ac].ima109,
                                 ima24 =g_ima[l_ac].ima24,
                                 imadate = g_today     #FUN-C30315 add
                           WHERE ima01 =g_ima_t.ima01
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_ima[l_ac].ima01,SQLCA.sqlcode,0)   #No.FUN-660115
                CALL cl_err3("upd","ima_file",g_ima_t.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660115
                LET g_ima[l_ac].* = g_ima_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i130_bcl
                COMMIT WORK
             END IF
         END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ima[l_ac].* = g_ima_t.*
               END IF
               CLOSE i130_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i130_bcl
            COMMIT WORK
 
       #start FUN-640212 add
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(ima109)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_azf"
                 LET g_qryparam.default1 = g_ima[l_ac].ima109
                 LET g_qryparam.arg1     = "8"
                 CALL cl_create_qry() RETURNING g_ima[l_ac].ima109
                #--------------No.MOD-770135 modify
                #DISPLAY g_ima[l_ac].ima109 TO FROMONLY.ima109
                 DISPLAY g_ima[l_ac].ima109 TO ima109
                #--------------No.MOD-770135 end
                 NEXT FIELD ima109
           END CASE
       #end FUN-640212 add
 
#       ON ACTION CONTROLN
#           CALL i130_b_askkey()
#           LET l_exit_sw = "n"
#           EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ima01) AND l_ac > 1 THEN
                LET g_ima[l_ac].* = g_ima[l_ac-1].*
                NEXT FIELD ima01
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
 
    CLOSE i130_bcl
   #COMMIT WORK
END FUNCTION
 
FUNCTION i130_b_askkey()
    CLEAR FORM
    CALL g_ima.clear()
    CONSTRUCT g_wc ON ima01,ima02,ima021,ima08,ima109,ima24,ima100,ima101,ima102   #FUN-640212 add ima109,ima24
         FROM s_ima[1].ima01 ,s_ima[1].ima02 ,s_ima[1].ima021,s_ima[1].ima08,
              s_ima[1].ima109,s_ima[1].ima24,   #FUN-640212 add
              s_ima[1].ima100,s_ima[1].ima101,s_ima[1].ima102
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
 
       #start FUN-640212 add
        ON ACTION controlp
           CASE
              WHEN INFIELD(ima109)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_azf"
                 LET g_qryparam.state    = "c"
                 LET g_qryparam.arg1     = "8"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO ima109
                 NEXT FIELD ima109
           END CASE
       #end FUN-640212 add
 
       #No.FUN-580031 --start--     HCN
       ON ACTION qbe_select
          CALL cl_qbe_select()
       ON ACTION qbe_save
          CALL cl_qbe_save()
       #No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i130_b_fill(g_wc)
END FUNCTION
 
FUNCTION i130_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680104 VARCHAR(200)
 
    LET g_sql =
        "SELECT ima01,ima02,ima021,ima08,ima109,ima24,ima100,ima101,ima102,'' ",   #FUN-640212 add ima109,ima24
        " FROM ima_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i130_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i130_pb
 
    CALL g_ima.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)
    IF STATUS THEN CALL cl_err('foreach:',STATUS,1) END IF
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel #FUN-4B0003
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#Patch....NO.TQC-610036 <001> #
 
#start FUN-640212 add
FUNCTION i130_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
 
   CALL cl_set_comp_entry("ima100,ima101,ima102",TRUE)
 
END FUNCTION
 
FUNCTION i130_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680104 VARCHAR(1)
   
   IF g_ima[l_ac].ima24 = 'N' THEN
      CALL cl_set_comp_entry("ima100,ima101,ima102",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION i130_set_required()
 
   IF g_ima[l_ac].ima24 = 'Y' THEN
      CALL cl_set_comp_required("ima100,ima101,ima102",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i130_set_no_required()
 
   CALL cl_set_comp_required("ima100,ima101,ima102",FALSE)
 
END FUNCTION
#--------------No.MOD-6C0127 add
FUNCTION i130_combo()
   DEFINE comb_value LIKE type_file.chr1000
   DEFINE comb_item  LIKE type_file.chr1000
  
   IF g_ima[l_ac].ima101 = '1' THEN
      LET comb_value = '1,2,3'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-042' AND ze02=g_lang
   ELSE
      LET comb_value = '1,2,3,4'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-043' AND ze02=g_lang
  END IF
#No.FUN-A80063 --begin
   IF g_ima[l_ac].ima101 MATCHES '[34]' THEN
      LET comb_value = '1,2,3,4,5,6,7'   
      SELECT ze03 INTO comb_item FROM ze_file
                  WHERE ze01='aqc-044' AND ze02=g_lang
   END IF
#No.FUN-A80063 --end
 
  CALL cl_set_combo_items('ima102',comb_value,comb_item)
END FUNCTION
#--------------No.MOD-6C0127 end
#end FUN-640212 add
