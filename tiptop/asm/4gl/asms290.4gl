# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asms290.4gl
# Descriptions...: 行業包參數設定作業
# Date & Author..: 05/06/24 by Pengu 
# Modify.........: 05/07/11 By Carrier 新加sma903
# Modify.........: No.FUN-570205 05/07/27 By saki 更動料件編號長度後，詢問是否更新zaa資料
# Modify.........: No.FUN-580137 05/08/25 By Kevin 若選定多單位and 選定母子單位時,自動讓sma116='Y',並且此欄位變NOENTRY 
# Modify.........: Nl:FUN-5A0126 05/10/19 By echo 更動使用BOM特性代碼/使用雙單位設定後，顯示異動提示訊息，再至p_zaa設定調整，而不直接改變p_zaa中對應屬性的隱藏碼或長度
# Modify.........: No.MOD-5A0223 05/10/21 By will 增加多屬性子料件的分隔符 
# Modify.........: No.TQC-5B0214 05/12/05 By kim 當使用多單位='Y',且使用多單位方式='兩者'時,計價單位應該為打勾,且為Noentry
# Modify.........: No.FUN-610022 06/01/10 By jackie 料件多屬性設置增加一個參數sma909 新增多屬性料件時,復制BOM
# Modify.........: No.TQC-610095 06/01/18 By kevin 分隔符號應改為用1.-  2._ 顯示
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610090 06/01/24 By Nicola 新增欄位sma123
# Modify.........: No.FUN-640013 06/03/27 By Rayven 新增欄位sma907,sma908
# Modify.........: No.MOD-650009 06/05/03 By Claire 隨意測試勾選會發生無法按確定的問題
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-710037 07/01/16 By kim 加入行業別頁籤
# Modify.........: NO.FUN-710029 07/02/02 by Yiting 當選擇使用母子單位時，計價單位必勾選二者
# Modify.........: NO.FUN-720009 07/02/07 by kim 行業別架構變更
# Modify.........: NO.FUN-730018 07/03/23 by kim 行業別架構
# Modify.........: No.FUN-750068 07/07/06 By saki 行業別選項用lib製作
# Modify.........: No.FUN-810017 08/01/07 By jan 新增服飾作業
# Modify.........: No.FUN-820046 08/02/22 By wuad 新增欄位sma128
# Modify.........: No.FUN-830114 08/03/25 By jan 當為服飾業時，sma909隱藏
#                                                當同時勾選sma115和sma128時，應跳出對話框
#                                                "多單位和混合包裝不能同時使用"，去掉勾選后才能選另一個
# Modify.........: No.FUN-840096 08/04/20 By jan 修改服飾作業
# Modify.........: No.MOD-860081 08/06/09 By jamie ON IDLE問題
# Modify.........: No.FUN-870124 08/09/11 By jan 混和包裝僅供服飾業使用
# Modify.........: No.TQC-970306 09/07/28 By sabrina 第786行MATCHES [2]少了單引號 
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.TQC-B30119 11/03/15 By lilingyu 當為slk行業別時,隱藏參數sma908(是否允許訂單錄入時新增料件)
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80133 11/08/19 By jason 刪除'工序移轉檢查製程報工'選項
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_sma_o         RECORD LIKE sma_file.*,  # 參數檔
       g_sma_t         RECORD LIKE sma_file.*,  # 參數檔
       g_sma903_1      LIKE type_file.chr1,   #No.FUN-690010CHAR(1),  #No.FUN-570036
       g_sma903_2      LIKE type_file.chr1    #No.FUN-690010CHAR(1)   #No.FUN-570036
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
MAIN
 
   OPTIONS 
      INPUT NO WRAP
   DEFER INTERRUPT 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   CALL asms290()
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
 
END MAIN  
 
FUNCTION asms290()
   DEFINE p_row,p_col LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
 
   LET p_row = 5 LET p_col = 35
 
   OPEN WINDOW asms290_w AT p_row,p_col
     WITH FORM "asm/42f/asms290" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   IF g_sma.sma124 = "slk" THEN
      CALL cl_set_comp_visible("sma127,sma128",TRUE)   #No.FUN-870124 ADD sma128
   ELSE
      CALL cl_set_comp_visible("sma127,sma128",FALSE)  #No.FUN-870124 ADD sma128
   END IF
 
   IF g_sma.sma124 = "slk" THEN
      CALL cl_set_comp_visible("sma909,sma908",FALSE)  #TQC-B30119 add sma908
   ELSE
      CALL cl_set_comp_visible("sma909,sma908",TRUE)   #TQC-B30119 add sma908
   END IF
 
   CALL cl_set_combo_industry("smb")   #No.FUN-750068
   
   CALL asms290_show()
 
   LET g_action_choice=""
   CALL asms290_menu()
 
   CLOSE WINDOW asms290_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #No.CHI-960043
END FUNCTION
 
FUNCTION asms290_show()
 
   SELECT * INTO g_sma.*
     FROM sma_file
    WHERE sma00 = '0'
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
      RETURN
   END IF
 
   CALL s290_def()
   DISPLAY BY NAME g_sma.sma115,g_sma.sma116,g_sma.sma117,g_sma.sma118,
                   g_sma.sma127,               #No.FUN-810017 #FUN-B80133 del sma126
                   g_sma.sma128,                            #No.FUN-820046
                   g_sma.sma120,g_sma.sma121,g_sma.sma122,g_sma.sma123,  #No.FUN-640013
                   g_sma.sma909,g_sma.sma907,g_sma.sma908,  #No.FUN-640013
                   g_sma.sma46
 
   DISPLAY g_sma.sma124 TO FORMONLY.smb #FUN-730018
   LET g_sma903_1 = g_sma.sma903[1,1]
   DISPLAY g_sma903_1 TO FORMONLY.sma903_1
   LET g_sma903_2 = g_sma.sma903[2,2]
   DISPLAY g_sma903_2 TO FORMONLY.sma903_2
                   
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION asms290_menu()
 
   MENU ""
      ON ACTION modify 
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
               CALL asms290_u()
            END IF
 
      ON ACTION help 
         CALL cl_show_help()
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_combo_industry("smb")         #No.FUN-750068
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
      
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
     
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
      
      LET g_action_choice = "exit"
      CONTINUE MENU
      
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
         LET INT_FLAG=FALSE        #MOD-570244 mars
         LET g_action_choice = "exit"
         EXIT MENU
 
   END MENU
 
END FUNCTION
 
FUNCTION asms290_u()
   DEFINE lc_hidden   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)                      #No.FUN-570205
   DEFINE l_gae04     LIKE gae_file.gae04          #No.FUN-5A0126
 
   MESSAGE ""
   CALL cl_opmsg('u')
 
   LET g_forupd_sql = "SELECT * FROM sma_file",
                      "  WHERE sma00 = ?",
                      "   FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE sma_curl CURSOR FROM  g_forupd_sql
 
   BEGIN WORK
 
 
   OPEN sma_curl USING '0'
 
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('open cursor',SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FETCH sma_curl INTO g_sma.*
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      RETURN
   END IF
 
   LET g_sma_o.* = g_sma.*
   LET g_sma_t.* = g_sma.*
 
   CALL s290_def()
 
   DISPLAY BY NAME g_sma.sma115,g_sma.sma116,g_sma.sma117,g_sma.sma118, 
                   g_sma.sma120,g_sma.sma121,g_sma.sma122,g_sma.sma46,  #No.MOD-5A0223
                   g_sma.sma127,    #No.FUN-810017 #FUN-B80133 del sma126
                   g_sma.sma128,                 #No.FUN-820046
                   g_sma.sma909,g_sma.sma123,g_sma.sma907,g_sma.sma908       #No.FUN-640013
                   
   IF cl_null(g_sma.sma124) THEN
      LET g_sma.sma124=s_industry_init()
   END IF
   DISPLAY g_sma.sma124 TO FORMONLY.smb #FUN-730018
 
   LET g_sma903_1 = g_sma.sma903[1,1]
   DISPLAY g_sma903_1 TO FORMONLY.sma903_1
   LET g_sma903_2 = g_sma.sma903[2,2]
   DISPLAY g_sma903_2 TO FORMONLY.sma903_2
 
   WHILE TRUE
      CALL asms290_i()
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      LET g_sma.sma903[1,1] = g_sma903_1
      LET g_sma.sma903[2,2] = g_sma903_2
 
      CALL sma46_def() #No.TQC-610095
 
      UPDATE sma_file SET sma115 = g_sma.sma115,
                          sma116 = g_sma.sma116,
                          sma117 = g_sma.sma117,
                          sma903 = g_sma.sma903,
                          sma118 = g_sma.sma118,
                          sma120 = g_sma.sma120,
                          sma121 = g_sma.sma121,
                          sma122 = g_sma.sma122,
                          sma123 = g_sma.sma123,   #No.FUN-610090
                          sma124 = g_sma.sma124,  #FUN-710037
                          #sma126 = g_sma.sma126,   #No.FUN-810017 #FUN-B80133 mark
                          sma127 = g_sma.sma127,   #No.FUN-810017
                          sma128 = g_sma.sma128,   #No.FUN-820046
                          sma46 = g_sma.sma46,  #No.MOD-5A0223  --add
                          sma909 = g_sma.sma909, #No.FUN-640013
                          sma907 = g_sma.sma907, #No.FUN-640013
                          sma908 = g_sma.sma908, #No.FUN-640013
                          smamodu=g_user,
                          smadate=TODAY
       WHERE sma00 = '0'
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","sma_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660138
         CONTINUE WHILE
      ELSE
         IF (g_sma.sma118 != g_sma_t.sma118) OR cl_null(g_sma_t.sma118) THEN
 
            SELECT gae04 INTO l_gae04 FROM gae_file
             WHERE gae01 = 'p_zaa'
               AND gae02 = 'zaa14_M'
               AND gae03 = g_lang
            CALL cl_err_msg("",'lib-303',l_gae04 CLIPPED || "|" || "M" || "|" || l_gae04 CLIPPED,1)
         END IF
 
         IF (g_sma.sma115 != g_sma_t.sma115) OR cl_null(g_sma_t.sma115) THEN
 
            SELECT gae04 INTO l_gae04 FROM gae_file
             WHERE gae01 = 'p_zaa'
               AND gae02 = 'zaa14_L'
               AND gae03 = g_lang
            CALL cl_err_msg("",'lib-303',l_gae04 CLIPPED || "|" || "L" || "|" || l_gae04 CLIPPED,1)
         END IF
      END IF
 
      UNLOCK TABLE sma_file
      EXIT WHILE
   END WHILE
 
   CLOSE sma_curl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION asms290_i()
   DEFINE l_dir      LIKE type_file.chr1,   #No.FUN-690010    VARCHAR(01),
          l_dir1     LIKE type_file.chr1,   #No.FUN-690010    VARCHAR(01),
          l_dir2     LIKE type_file.chr1    #No.FUN-690010    VARCHAR(01)
   DEFINE li_result  LIKE type_file.num5    #No.FUN-610090  #No.FUN-690010 SMALLINT
   DEFINE g_t1       LIKE sma_file.sma123   #No.FUN-610090  #No.FUN-690010 VARCHAR(5)
   DEFINE l_sma123   LIKE sma_file.sma123   #No.FUN-610090
    
   INPUT g_sma.sma124,g_sma.sma127,  #No.FUN-810017 #FUN-B80133 del sma126
         g_sma.sma128,              #No.FUN-820046
         g_sma.sma118,g_sma.sma121,g_sma.sma115,               #FUN-710037
         g_sma.sma122,g_sma.sma117,g_sma903_1,g_sma903_2,      #No.FUN-570036
         g_sma.sma123,g_sma.sma116,g_sma.sma120,g_sma.sma46,   #No.MOD-5A0223  #No.FUN-610090
         g_sma.sma909,g_sma.sma907,g_sma.sma908 #No.FUN-640013
         WITHOUT DEFAULTS 
    FROM smb,sma127,sma128,              #No.FUN-820046 #FUN-B80133 del sma126
         sma118,sma121,sma115,sma122,sma117,sma903_1,sma903_2,sma123,  #No.FUN-610090 #FUN-710037 #FUN-730018 #No.FUN-810017
         sma116,sma120,sma46,  #No.FUN-570036
         sma909,sma907,sma908     #No.FUN-640013
        
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL s290_set_entry()
         CALL s290_set_no_entry()
         LET g_before_input_done = TRUE
 
      ON CHANGE sma118
         IF g_sma.sma118 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma118 = g_sma_o.sma118
            DISPLAY BY NAME g_sma.sma118
            NEXT FIELD sma118
         END IF
         IF g_sma.sma118 ='N' THEN
            LET g_sma.sma121 = NULL
            DISPLAY BY NAME g_sma.sma121
         END IF
         CALL s290_set_entry()
         CALL s290_set_no_entry()
 
      ON CHANGE sma128
         IF g_sma.sma128 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma128 = g_sma_o.sma128
            DISPLAY BY NAME g_sma.sma128
            NEXT FIELD sma128
         END IF
         IF g_sma.sma128 = 'Y' THEN             #No.FUN-840086
         IF g_sma.sma115 = 'Y' THEN
            CALL cl_err('','asm-114',1)
            LET g_sma.sma128 = 'N'
            DISPLAY BY NAME g_sma.sma128
         END IF
         END IF
 
      ON CHANGE sma115
         IF g_sma.sma115 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma115 = g_sma_o.sma115
            DISPLAY BY NAME g_sma.sma115
            NEXT FIELD sma115
         END IF
         IF g_sma.sma115 ='N' THEN
            LET g_sma.sma122 = NULL
            DISPLAY BY NAME g_sma.sma122
            LET g_sma.sma116 = '0' 
            DISPLAY BY NAME g_sma.sma116
         ELSE                                     #No.FUN-820046
            IF g_sma.sma128 = 'Y' THEN            #No.FUN-840096
            CALL cl_err('','asm-114',1)
            LET g_sma.sma115 = 'N'
            DISPLAY BY NAME g_sma.sma115
            END IF
         END IF
         CALL s290_set_entry()
         CALL s290_set_no_entry()
 
      ON CHANGE sma122
         IF NOT cl_null(g_sma.sma122) THEN
            CALL s290_set_entry()
            CALL s290_set_no_entry()
         END IF
         
      BEFORE FIELD FORMONLY.smb
         LET g_sma.sma124 = FGL_DIALOG_GETBUFFER()
         IF g_sma.sma124 = "slk" THEN
            LET g_sma.sma909 = 'N'                     #No.FUN-830114
            CALL cl_set_comp_visible("sma127,sma128",TRUE)#No.FUN-870124
            CALL cl_set_comp_visible("sma909,sma908",FALSE)   #No.FUN-830114  #TQC-B30119 add sma908
         ELSE
            LET g_sma.sma127 = 'N'
            LET g_sma.sma128 = 'N'                     #No.FUN-870124
            CALL cl_set_comp_visible("sma127,sma128",FALSE)  #No.FUN-870124
            CALL cl_set_comp_visible("sma909,sma908",TRUE)    #No.FUN-830114  #TQC-B30119 add sma908
         END IF
         
      ON CHANGE smb
         LET g_sma.sma124 = FGL_DIALOG_GETBUFFER()
         IF g_sma.sma124 = "slk" THEN
            LET g_sma.sma909 = 'N'                     #No.FUN-830114
            CALL cl_set_comp_visible("sma127,sma128",TRUE) #No.FUN-870124
            CALL cl_set_comp_visible("sma909,sma908",FALSE)   #No.FUN-830114 #TQC-B30119 add sma908 
         ELSE
            LET g_sma.sma127 = 'N'
            LET g_sma.sma128 = 'N'          #No.FUN-870124
            CALL cl_set_comp_visible("sma127,sma128",FALSE) #No.FUN-870124
            CALL cl_set_comp_visible("sma909,sma908",TRUE)    #No.FUN-830114 #TQC-B30119 add sma908
         END IF
       
      AFTER FIELD FORMONLY.smb
         LET g_sma.sma124 = FGL_DIALOG_GETBUFFER()
 
      
      AFTER FIELD sma116 
         IF g_sma.sma116 NOT MATCHES "[0123]" THEN   #No.FUN-610076
            LET g_sma.sma116 = g_sma_o.sma116
            DISPLAY BY NAME g_sma.sma116
            NEXT FIELD sma116
         END IF 
         IF (g_sma.sma122 ='1') OR (g_sma.sma122 ='3') THEN
            IF g_sma.sma116 = "0" THEN
               CALL cl_err('','asm-419',0)
               NEXT FIELD sma116
            END IF
         END IF
         IF g_sma.sma122 = '1' THEN
             IF g_sma.sma116 <> '3' THEN
                 CALL cl_err('','asm-426',0)
                 NEXT FIELD sma116
             END IF
         END IF
      BEFORE FIELD sma117
         CALL s290_set_entry()
      
      AFTER FIELD sma117 
         IF g_sma.sma117 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma117 = g_sma_o.sma117
            DISPLAY BY NAME g_sma.sma117
            NEXT FIELD sma117
         END IF 
         CALL s290_set_no_entry()
      
      AFTER FIELD sma903_1
         IF g_sma903_1 NOT MATCHES "[12]" THEN 
            LET g_sma903_1 = '1'
            DISPLAY g_sma903_1 TO FORMONLY.sma903_1
            NEXT FIELD sma903_1
         END IF 
      
      AFTER FIELD sma903_2
         IF g_sma903_2 NOT MATCHES "[YN]" THEN 
            LET g_sma903_2 = 'Y'
            DISPLAY g_sma903_2 TO FORMONLY.sma903_2
            NEXT FIELD sma903_2
         END IF 
      
      AFTER FIELD sma123
         IF NOT cl_null(g_sma.sma123) THEN
             CALL s_check_no("aim",g_sma.sma123,g_sma_t.sma123,"4","sma_file","sma123","")
                 RETURNING li_result,l_sma123
             IF (NOT li_result) THEN
                NEXT FIELD sma123
             END IF
         END IF
 
      AFTER FIELD sma120 
         IF g_sma.sma120 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma120 = g_sma_o.sma120
            DISPLAY BY NAME g_sma.sma120
            NEXT FIELD sma120
         END IF 

         IF g_sma.sma120 = 'N' THEN
	    LET g_sma.sma907 = 'N'
            LET g_sma.sma908 = 'N'
            LET g_sma.sma909 = 'N'
            DISPLAY BY NAME g_sma.sma907
            DISPLAY BY NAME g_sma.sma908
            DISPLAY BY NAME g_sma.sma909
         END IF
 
      AFTER FIELD sma128
         IF g_sma.sma128 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma128 = g_sma_o.sma128
            DISPLAY BY NAME g_sma.sma128
            NEXT FIELD sma128
         END IF
         IF g_sma.sma128 = 'Y' THEN
         IF g_sma.sma115 = 'Y' THEN
            CALL cl_err('','asm-114',1)
            LET g_sma.sma128 = 'N'
            DISPLAY BY NAME g_sma.sma128
            NEXT FIELD sma128
         END IF
         END IF
 
      AFTER FIELD sma115
         IF g_sma.sma115 NOT MATCHES "[YN]" THEN 
            LET g_sma.sma115 = g_sma_o.sma115
            DISPLAY BY NAME g_sma.sma115
            NEXT FIELD sma115
         END IF
         IF g_sma.sma115 ='N' THEN
            LET g_sma.sma122 = NULL
            DISPLAY BY NAME g_sma.sma122
            LET g_sma.sma116 = '0' 
            DISPLAY BY NAME g_sma.sma116
         ELSE                                     
            IF g_sma.sma128 = 'Y' THEN            
            CALL cl_err('','asm-114',1)
            LET g_sma.sma115 = 'N'
            DISPLAY BY NAME g_sma.sma115
            NEXT FIELD sma115
            END IF
         END IF
 
      AFTER FIELD sma907
         IF g_sma.sma907 NOT MATCHES "[YN]" THEN
            LET g_sma.sma907 = 'N'
            DISPLAY BY NAME g_sma.sma907
            NEXT FIELD sma907
         END IF
         IF g_sma.sma120 = 'N' AND g_sma.sma907 = 'Y' THEN
            LET g_sma.sma907 = 'N'
            DISPLAY BY NAME g_sma.sma907
            CALL cl_err('','asm-075',0)
            NEXT FIELD sma907
         END IF
            
      AFTER FIELD sma908
         IF g_sma.sma908 NOT MATCHES "[YN]" THEN
            LET g_sma.sma908 = 'N'
            DISPLAY BY NAME g_sma.sma908
            NEXT FIELD sma908
         END IF
         IF g_sma.sma120 = 'N' AND g_sma.sma908 = 'Y' THEN
            LET g_sma.sma908 = 'N'
            DISPLAY BY NAME g_sma.sma908
            CALL cl_err('','asm-075',0)
            NEXT FIELD sma908
         END IF
 
      AFTER FIELD sma909
         IF g_sma.sma909 NOT MATCHES "[YN]" THEN
            LET g_sma.sma909 = 'N'
            DISPLAY BY NAME g_sma.sma909
            NEXT FIELD sma909
         END IF
         IF g_sma.sma120 = 'N' AND g_sma.sma909 = 'Y' THEN
            LET g_sma.sma909 = 'N'
            DISPLAY BY NAME g_sma.sma909
            CALL cl_err('','asm-075',0)
            NEXT FIELD sma909
         END IF
      
      ON CHANGE sma120
         CALL s290_set_entry()
         CALL s290_set_no_entry()
      
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
            
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
      
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(sma123)
               LET  g_t1=s_get_doc_no(g_sma.sma123)
               CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1  #TQC-670008
               LET  g_sma.sma123 = g_t1
               DISPLAY BY NAME g_sma.sma123
               NEXT FIELD sma123
            OTHERWISE EXIT CASE
         END CASE
 
      AFTER INPUT
 
         IF g_sma.sma117='Y' THEN
            IF g_sma903_1 IS NULL OR g_sma903_1 NOT MATCHES '[12]' THEN
               NEXT FIELD sma903_1
            END IF
         END IF
         IF (g_sma.sma122 ='1') OR (g_sma.sma122 ='3') THEN
            IF g_sma.sma116 = "0" THEN
               NEXT FIELD sma116
            END IF
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
 
   END INPUT
 
END FUNCTION
 
FUNCTION s290_def()
 
   IF cl_null(g_sma.sma118) THEN 
      LET g_sma.sma118 = 'N'
   END IF 
 
   IF cl_null(g_sma.sma115) THEN
      LET g_sma.sma115 = 'N'
   END IF 
 
   IF cl_null(g_sma.sma116) THEN
      LET g_sma.sma116 = '0'   #No.FUN-610076
   END IF 
 
   IF cl_null(g_sma.sma117) THEN
      LET g_sma.sma117 = 'N'
   END IF 
 
   IF cl_null(g_sma.sma120) THEN
      LET g_sma.sma120 = 'N'
   END IF 
 
   IF g_sma.sma46 = "_" THEN  #No.TQC-610095
      LET g_sma.sma46 = '1'
   END IF 
 
   IF g_sma.sma46 = "-" THEN  #No.TQC-610095
      LET g_sma.sma46 = '2'
   END IF
 
   IF cl_null(g_sma.sma907) THEN
      LET g_sma.sma907 = 'N'
   END IF 
 
   IF cl_null(g_sma.sma908) THEN
      LET g_sma.sma908 = 'N'
   END IF 
 
END FUNCTION
 
# No.TQC-610095 sma46存檔時須變更資料
FUNCTION sma46_def()
 
   IF g_sma.sma46 = '1' THEN 
      LET g_sma.sma46 = "_"
   END IF
 
   IF g_sma.sma46 = '2' THEN
      LET g_sma.sma46 = "-"
   END IF
 
END FUNCTION
 
FUNCTION s290_set_entry()
 
   IF g_sma.sma118 ='Y' THEN
      CALL cl_set_comp_entry("sma121",TRUE)
      CALL cl_set_comp_required("sma121",TRUE)
   END IF
 
   IF g_sma.sma115 ='Y' THEN
      CALL cl_set_comp_entry("sma122",TRUE)
      CALL cl_set_comp_required("sma122",TRUE)
   END IF
 
   IF g_sma.sma122 MATCHES "[13]" THEN
      CALL cl_set_comp_entry("sma117,sma903_1,sma903_2,sma123",TRUE)  #No.FUN-610090
   END IF
 
   IF INFIELD(sma117) THEN
      CALL cl_set_comp_entry("sma903_1,sma903_2,sma123",TRUE)  #No.FUN-610090
      CALL cl_set_comp_required("sma903_1,sma903_2,sma123",FALSE)  #No.FUN-610090
   END IF
  
   IF g_sma.sma120 = 'Y' THEN
      CALL cl_set_comp_entry("sma46",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION s290_set_no_entry()
 
   IF g_sma.sma118 ='N' THEN
      CALL cl_set_comp_entry("sma121",FALSE)
      CALL cl_set_comp_required("sma121",FALSE)
   END IF
 
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_entry("sma122",FALSE)
      CALL cl_set_comp_required("sma122",FALSE)  
   END IF
 
   IF g_sma.sma122 MATCHES '[2]' OR cl_null(g_sma.sma122) THEN     #TQC-970306 add
      LET g_sma.sma117 ='N'
      DISPLAY BY NAME g_sma.sma117
      LET g_sma903_1=''  DISPLAY g_sma903_1 TO FORMONLY.sma903_1
      LET g_sma903_2='N' DISPLAY g_sma903_2 TO FORMONLY.sma903_2
      CALL cl_set_comp_entry("sma117,sma903_1,sma903_2,sma123",FALSE)  #No.FUN-610090
   END IF
 
   IF INFIELD(sma117) THEN
      IF g_sma.sma117 ='Y' THEN
         CALL cl_set_comp_required("sma903_1,sma903_2,sma123",TRUE)  #No.FUN-610090
      ELSE
         LET g_sma903_1=NULL
         LET g_sma903_2='N' 
         DISPLAY g_sma903_1 TO FORMONLY.sma903_1
         DISPLAY g_sma903_2 TO FORMONLY.sma903_2
         CALL cl_set_comp_entry("sma903_1,sma903_2,sma123",FALSE)  #No.FUN-610090
      END IF
   END IF
 
   IF g_sma.sma120 = 'N' THEN
      CALL cl_set_comp_entry("sma46",FALSE)
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼 
