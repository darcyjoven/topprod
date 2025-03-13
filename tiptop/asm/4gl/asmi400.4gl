# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: asmi400.4gl
# Descriptions...: 工作行事曆維護作業
# Date & Author..: 90/08/14 By TED
# Release 4.0....: 92/07/25 By Jones
# Modify.........: No.MOD-530852 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-B10031 11/01/05 By lilingyu 程序進入單身後,點擊任何欄位程序跳出
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-C50080 12/05/10 By qiaozy  點擊“單身”按鈕，作業會自動關閉
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_sme3        DYNAMIC ARRAY OF RECORD
   	      sme01_1 LIKE sme_file.sme01,
              sme01_2 LIKE sme_file.sme01,
              sme01_3 LIKE sme_file.sme01,
              sme01_4 LIKE sme_file.sme01,
              sme01_5 LIKE sme_file.sme01,
              sme01_6 LIKE sme_file.sme01,
              sme01_7 LIKE sme_file.sme01
	END RECORD,
   	g_sme4        DYNAMIC ARRAY OF RECORD
   	      sme01_1 LIKE sme_file.sme01,
              sme01_2 LIKE sme_file.sme01,
              sme01_3 LIKE sme_file.sme01,
              sme01_4 LIKE sme_file.sme01,
              sme01_5 LIKE sme_file.sme01,
              sme01_6 LIKE sme_file.sme01,
              sme01_7 LIKE sme_file.sme01,
              sme02_1 LIKE sme_file.sme02,
              sme02_2 LIKE sme_file.sme02,
              sme02_3 LIKE sme_file.sme02,
              sme02_4 LIKE sme_file.sme02,
              sme02_5 LIKE sme_file.sme02,
              sme02_6 LIKE sme_file.sme02,
              sme02_7 LIKE sme_file.sme02
	END RECORD,
 
   	g_sme_t       RECORD 			#FOR BACK UP
              sme01   LIKE  sme_file.sme01,
              sme02   LIKE  sme_file.sme02
	END RECORD,
 
        g_sme01_t     LIKE sme_file.sme01,
        g_rec_b       LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
 
	l_n,l_ac      LIKE type_file.num10,   #No.FUN-690010INTEGER,
	l_wc  	      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(200)
	l_sql 	      LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(200)
        g_date	      LIKE type_file.dat,     #No.FUN-690010DATE,		#ACCEPT INPUT DATE
	g_week        LIKE type_file.num10   #No.FUN-690010INTEGER, 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_msg           LIKE ze_file.ze03  #No.FUN-690010 VARCHAR(72)
 
MAIN               
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW i400_w WITH FORM "asm/42f/asmi400"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    WHILE TRUE
       CALL i400_cs() RETURNING g_date
 
       CALL cl_getmsg('mfg0401',g_lang) RETURNING g_msg   #顯示作業操作方法
       DISPLAY g_msg AT 1,1 
       CALL cl_getmsg('mfg3199',g_lang) RETURNING g_msg   #顯示作業操作方法
       DISPLAY g_msg AT 2,1 
 
       CALL i400_b(g_date)
 
       CALL i400_menu()
 
    END WHILE
 
    CLOSE WINDOW i400_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0089
END MAIN
 
FUNCTION i400_cs()
     DEFINE     l_i     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
                l_week  LIKE type_file.num10,   #No.FUN-690010 INTEGER,
                l_msg   LIKE type_file.chr1000,  #No.FUN-690010 VARCHAR(40),
	        l_d	LIKE type_file.num10,   #No.FUN-690010 INTEGER,   #0:星期日(123456類推)
                l_date  LIKE type_file.dat,     #No.FUN-690010 DATE,   	  #ACCEPT INPUT DATE
                l_sme01 LIKE sme_file.sme01
             
      LET l_ac = 1
 
      CALL cl_getmsg('mfg0400',g_lang) RETURNING l_msg
      LET l_date = NULL
 
      WHILE l_date IS NULL              # 讀入INPUT DATE
            LET INT_FLAG = 0  ######add for prompt bug
         PROMPT l_msg CLIPPED FOR l_date
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#               CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         END PROMPT
         IF INT_FLAG THEN LET INT_FLAG = 0 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
      END WHILE
 
      LET l_week=l_date MOD 7 USING '&'
      LET l_date=DATE(l_date-l_week+1)
 
      DISPLAY 'l_week is ',l_week,' and l_date is ',l_date
 
      DECLARE i400_cs CURSOR FOR
       SELECT sme01,sme02 FROM sme_file WHERE sme01 >= l_date 
        ORDER BY sme01
 
      CALL g_sme3.clear()
      CALL g_sme4.clear()
 
      INITIALIZE g_sme_t.* TO NULL
 
      LET g_cnt=1
      FOREACH i400_cs INTO g_sme_t.*
         IF SQLCA.sqlcode!=0 THEN
            CALL cl_err('forech error',SQLCA.sqlcode,1) EXIT FOREACH   
         END IF
         LET l_ac = g_sme_t.sme01 - l_date + 1	#計算ARRAY位置
         IF g_sme_t.sme02 = 'Y' THEN 
            LET l_sme01 = g_sme_t.sme01
         ELSE 
            LET l_sme01 = ' '      
         END IF
 
         CASE l_ac mod 7
           WHEN 1 LET g_sme3[g_cnt].sme01_1=l_sme01
                  LET g_sme4[g_cnt].sme01_1=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_1=g_sme_t.sme02
           WHEN 2 LET g_sme3[g_cnt].sme01_2=l_sme01
                  LET g_sme4[g_cnt].sme01_2=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_2=g_sme_t.sme02
           WHEN 3 LET g_sme3[g_cnt].sme01_3=l_sme01
                  LET g_sme4[g_cnt].sme01_3=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_3=g_sme_t.sme02
           WHEN 4 LET g_sme3[g_cnt].sme01_4=l_sme01
                  LET g_sme4[g_cnt].sme01_4=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_4=g_sme_t.sme02
           WHEN 5 LET g_sme3[g_cnt].sme01_5=l_sme01
                  LET g_sme4[g_cnt].sme01_5=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_5=g_sme_t.sme02
           WHEN 6 LET g_sme3[g_cnt].sme01_6=l_sme01
                  LET g_sme4[g_cnt].sme01_6=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_6=g_sme_t.sme02
           WHEN 0 LET g_sme3[g_cnt].sme01_7=l_sme01
                  LET g_sme4[g_cnt].sme01_7=g_sme_t.sme01
                  LET g_sme4[g_cnt].sme02_7=g_sme_t.sme02
                  LET g_cnt=g_cnt+1
         END CASE
         # TQC-630105----------start add by Joe
         IF g_cnt > g_max_rec THEN
            CALL cl_err( '', 9035, 0 )
	    EXIT FOREACH
         END IF
         # TQC-630105----------end add by Joe
 
      END FOREACH
      IF SQLCA.sqlcode!=0 THEN
         CALL cl_err('forech error',SQLCA.sqlcode,1) 
      END IF
#     CALL SET_COUNT(l_ac)
      LET g_rec_b = g_cnt 
#     CALL SET_COUNT(g_cnt)
      RETURN l_date
END FUNCTION
 
FUNCTION i400_menu()
 
   WHILE TRUE
      CALL i400_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN 
               CALL i400_b(g_date)
            END IF
         WHEN "exit"
             CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
             EXIT PROGRAM
      END CASE
   END WHILE
END FUNCTION
 
#單身
FUNCTION i400_b(g_date)
  DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    g_date          LIKE type_file.dat,     #No.FUN-690010 DATE,   
    l_date          LIKE type_file.dat,    #No.FUN-690010 DATE,
    l_sme01         LIKE sme_file.sme01,
    l_sme02         LIKE sme_file.sme02,
    l_allow_insert  LIKE type_file.chr1,  # Prog. Version..: '5.30.06-13.03.12(01),              #可新增否
    l_allow_delete  LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01)               #可刪除否
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    LET g_forupd_sql = 
       "SELECT sme01,sme02 FROM sme_file WHERE sme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i400_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    INPUT ARRAY g_sme3 WITHOUT DEFAULTS FROM s_sme.* 
        ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
#                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
            BEGIN WORK                      #MOD-B10031
 
        BEFORE ROW
#          BEGIN WORK                       #MOD-B10031
           DISPLAY "Error code:",SQLCA.sqlcode
           IF SQLCA.sqlcode THEN  
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
              EXIT PROGRAM 
           END if
           LET l_n  = ARR_COUNT()
           LET l_ac = ARR_CURR()
 
   #-----> 不允許使用者更改日期
 
        AFTER FIELD sme01_1
            IF g_sme4[l_ac].sme02_1 = 'Y' THEN
               LET g_sme3[l_ac].sme01_1=g_sme4[l_ac].sme01_1
            ELSE
               LET g_sme3[l_ac].sme01_1=''
            END IF
       
        AFTER FIELD sme01_2
            IF g_sme4[l_ac].sme02_2 = 'Y' THEN
               LET g_sme3[l_ac].sme01_2=g_sme4[l_ac].sme01_2
            ELSE
               LET g_sme3[l_ac].sme01_2=''
            END IF
       
        AFTER FIELD sme01_3
            IF g_sme4[l_ac].sme02_3 = 'Y' THEN
               LET g_sme3[l_ac].sme01_3=g_sme4[l_ac].sme01_3
            ELSE
               LET g_sme3[l_ac].sme01_3=''
            END IF
       
        AFTER FIELD sme01_4
            IF g_sme4[l_ac].sme02_4 = 'Y' THEN
               LET g_sme3[l_ac].sme01_4=g_sme4[l_ac].sme01_4
            ELSE
               LET g_sme3[l_ac].sme01_4=''
            END IF
       
        AFTER FIELD sme01_5
            IF g_sme4[l_ac].sme02_5 = 'Y' THEN
               LET g_sme3[l_ac].sme01_5=g_sme4[l_ac].sme01_5
            ELSE
               LET g_sme3[l_ac].sme01_5=''
            END IF
       
        AFTER FIELD sme01_6
            IF g_sme4[l_ac].sme02_6 = 'Y' THEN
               LET g_sme3[l_ac].sme01_6=g_sme4[l_ac].sme01_6
            ELSE
               LET g_sme3[l_ac].sme01_6=''
            END IF
       
        AFTER FIELD sme01_7
            IF g_sme4[l_ac].sme02_7 = 'Y' THEN
               LET g_sme3[l_ac].sme01_7=g_sme4[l_ac].sme01_7
            ELSE
               LET g_sme3[l_ac].sme01_7=''
            END IF
       
        AFTER INPUT
            IF INT_FLAG THEN                 #900423
               LET INT_FLAG = 0
               EXIT INPUT   
#MOD-B10031 --begin--               
            ELSE   
               CLOSE i400_bcl     
               COMMIT WORK                 
#MOD-B10031 --end--               
            END IF
 
        AFTER ROW 
             IF INT_FLAG THEN                 #900423
                LET INT_FLAG = 0
                ROLLBACK WORK     #TQC-C50080---ADD---
                EXIT INPUT
               #EXIT PROGRAM 
            END IF
 
        ON ACTION change_day 		     #改變工作日Y或N
           CASE
             WHEN INFIELD(sme01_1)
                  IF g_sme4[l_ac].sme02_1 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_1 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_1 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_1 = g_sme4[l_ac].sme01_1
                     LET g_sme4[l_ac].sme02_1 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_1
                  LET l_sme02=g_sme4[l_ac].sme02_1
 
             WHEN INFIELD(sme01_2)
                  IF g_sme4[l_ac].sme02_2 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_2 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_2 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_2 = g_sme4[l_ac].sme01_2
                     LET g_sme4[l_ac].sme02_2 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_2
                  LET l_sme02=g_sme4[l_ac].sme02_2
 
             WHEN INFIELD(sme01_3)
                  IF g_sme4[l_ac].sme02_3 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_3 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_3 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_3 = g_sme4[l_ac].sme01_3
                     LET g_sme4[l_ac].sme02_3 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_3
                  LET l_sme02=g_sme4[l_ac].sme02_3
 
             WHEN INFIELD(sme01_4)
                  IF g_sme4[l_ac].sme02_4 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_4 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_4 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_4 = g_sme4[l_ac].sme01_4
                     LET g_sme4[l_ac].sme02_4 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_4
                  LET l_sme02=g_sme4[l_ac].sme02_4
 
             WHEN INFIELD(sme01_5)
                  IF g_sme4[l_ac].sme02_5 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_5 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_5 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_5 = g_sme4[l_ac].sme01_5
                     LET g_sme4[l_ac].sme02_5 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_5
                  LET l_sme02=g_sme4[l_ac].sme02_5
 
             WHEN INFIELD(sme01_6)
                  IF g_sme4[l_ac].sme02_6 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_6 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_6 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_6 = g_sme4[l_ac].sme01_6
                     LET g_sme4[l_ac].sme02_6 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_6
                  LET l_sme02=g_sme4[l_ac].sme02_6
 
             WHEN INFIELD(sme01_7)
                  IF g_sme4[l_ac].sme02_7 = 'Y' THEN
                     LET g_sme3[l_ac].sme01_7 = ' '    #N:SHOW NOTHING
                     LET g_sme4[l_ac].sme02_7 = 'N'
                  ELSE
                     LET g_sme3[l_ac].sme01_7 = g_sme4[l_ac].sme01_7
                     LET g_sme4[l_ac].sme02_7 = 'Y'
                  END IF
                  LET l_sme01=g_sme4[l_ac].sme01_7
                  LET l_sme02=g_sme4[l_ac].sme02_7
 
           END CASE
 
           UPDATE sme_file SET sme02 = l_sme02
                  WHERE sme01 = l_sme01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0
              THEN
#             CALL cl_err('update sme_file',SQLCA.SQLCODE,1)   #No.FUN-660138
              CALL cl_err3("upd","sme_file",l_sme01,"",SQLCA.sqlcode,"","update sme_file",1)  #No.FUN-660138
#MOD-B10031 --begin--              
              CLOSE i400_bcl              
              ROLLBACK WORK                 
              EXIT INPUT                     
#           ELSE                            
#              COMMIT WORK                    
#MOD-B10031 --end--
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
 
#    CLOSE i400_bcl              #MOD-B10031
#    COMMIT WORK                 #MOD-B10031
END FUNCTION
 
FUNCTION i400_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sme3 TO s_sme.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION detail         
         LET g_action_choice="detail"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit" 
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
       #No.MOD-530852  --begin                                                   
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
       #No.MOD-530852  --end         
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
