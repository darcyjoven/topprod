# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: csfi010.4gl
# Descriptions...: 不良現象代碼維護作業
# Date & Author..: 98/02/24 By Dennon lai.
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-510044 05/01/21 By Mandy 報表轉XML
#
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.TQC-5C0064 05/12/13 By kevin 結束位置調整
# Modify.........: No.TQC-640100 06/04/08 By Echo 報表列印時會多產生一頁空白頁
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-860018 08/06/06 By TSD.SusanWu 報表改CR
# Modify.........: No.FUN-870144 08/07/29 By chenmoyan 追單到31區 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
 
    g_mianji           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        A       LIKE mianji.A,   #不良現象代碼
        B       LIKE mianji.B,   #不良現象說明
        C       LIKE mianji.C,    #碼別
        D       LIKE mianji.D,
        E       LIKE mianji.E,
        F       LIKE mianji.F 
                    END RECORD,
 
    g_mianji_t         RECORD                 #程式變數 (舊值)
        A       LIKE mianji.A,   #不良現象代碼
        B       LIKE mianji.B,   #不良現象說明
        C       LIKE mianji.C,    #碼別
        D       LIKE mianji.D,
        E       LIKE mianji.E,
        F       LIKE mianji.F 
                    END RECORD,
    l_za05          LIKE type_file.chr1000,  #No.FUN-690010 VARCHAR(40)
     g_wc2,g_sql     string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_sl            LIKE type_file.num5                 #No.FUN-690010 SMALLINT               #目前處理的SCREEN LINE
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109  #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE l_table        STRING                    #FUN-860018 add
DEFINE g_str          STRING                    #FUN-860018 add
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0085
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("CSF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
 
   ## --> FUN-860018 CR(1)
   ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> *** ##
   LET g_sql = 
               " a.mianji.a, ",
               " b.mianji.b, ",
               " c.mianji.c, ",
               " d.mianji.d, ",
               " e.mianji.e, ",
               " f.mianji.f  " 
 
   LET l_table = cl_prt_temptable("csfi010",g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
 
   LET g_sql = " INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,? ,?) "
   PREPARE insert_prep FROM g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err("insert_prep",SQLCA.sqlcode,1)
      EXIT PROGRAM
   END IF
   ## <-- FUN-860018 CR(1)
 
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i020_w AT p_row,p_col WITH FORM "csf/42f/csfi010"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    LET g_wc2 = '1=1' CALL i020_b_fill(g_wc2)
    CALL i020_menu()
    CLOSE WINDOW i020_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
         RETURNING g_time    #No.FUN-6A0085
END MAIN
 
FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN
               CALL i020_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_mianji),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_q()
   CALL i020_b_askkey()
END FUNCTION
 
FUNCTION i020_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,                 #No.FUN-690010 VARCHAR(01), 
    l_allow_delete  LIKE type_file.chr1                  #No.FUN-690010 VARCHAR(01) 
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT A,B,C,D,E,F FROM mianji WHERE A=?  FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_mianji WITHOUT DEFAULTS FROM s_mianji.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,
              UNBUFFERED, INSERT ROW = l_allow_insert,
              DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT                                                              
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               #CKP
               LET g_mianji_t.* = g_mianji[l_ac].*  #BACKUP
               LET p_cmd='u'
#No.FUN-570109 --start                                                          
               LET g_before_input_done = FALSE                                  
               CALL i020_set_entry(p_cmd)                                       
               CALL i020_set_no_entry(p_cmd)                                    
               LET g_before_input_done = TRUE                                   
#No.FUN-570109 --end     
               BEGIN WORK
               OPEN i020_bcl USING g_mianji_t.a
               IF STATUS THEN
                  CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_mianji_t.a,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  FETCH i020_bcl INTO g_mianji[l_ac].* 
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #CKP
           #NEXT FIELD rmk01
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start                                                          
            LET g_before_input_done = FALSE                                     
            CALL i020_set_entry(p_cmd)                                          
            CALL i020_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
#No.FUN-570109 --end    
            INITIALIZE g_mianji[l_ac].* TO NULL      #900423
            LET g_mianji_t.* = g_mianji[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmk01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            #CKP
            CANCEL INSERT
         END IF
         INSERT INTO mianji_file(a,b,c,d)
         VALUES(g_mianji[l_ac].a,g_mianji[l_ac].b,
                g_mianji[l_ac].c,g_mianji[l_ac].d)
         IF SQLCA.sqlcode THEN 
    #         CALL cl_err(g_mianji[l_ac].rmk01,SQLCA.sqlcode,0) # FUN-660111
           CALL cl_err3("ins","mianji",g_mianji[l_ac].a,"",SQLCA.sqlcode,"","",1) # FUN-660111
             #CKP
             ROLLBACK WORK
             CANCEL INSERT
         ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2  
             COMMIT WORK
         END IF
 
        AFTER FIELD rmk01                        #check 編號是否重複
            IF g_mianji[l_ac].a IS NOT NULL THEN
               IF g_mianji[l_ac].a != g_mianji_t.a OR
                 (g_mianji[l_ac].a IS NOT NULL AND g_mianji_t.a IS NULL) THEN
                  SELECT count(*) INTO l_n FROM mianji
                   WHERE a = g_mianji[l_ac].a
                  IF l_n > 0 THEN
                     CALL cl_err('',-239,0)
                     LET g_mianji[l_ac].a = g_mianji_t.a
                     NEXT FIELD a
                  END IF
               END IF
            END IF

 {
        AFTER FIELD rmk03    
            IF g_mianji[l_ac].rmk03 IS NOT NULL THEN 
               IF g_mianji[l_ac].rmk03 NOT MATCHES '[12]' THEN 
                  NEXT FIELD rmk03
               END IF
            END IF
 }
        BEFORE DELETE                            #是否取消單身
            IF g_mianji_t.a IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM mianji WHERE a = g_mianji_t.a
                IF SQLCA.sqlcode THEN
   #                CALL cl_err(g_mianji_t.rmk01,SQLCA.sqlcode,0)  # FUN-660111
            CALL cl_err3("del","mianji",g_mianji_t.a,"",SQLCA.sqlcode,"","",1) # FUN-660111
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK" 
                CLOSE i020_bcl     
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_mianji[l_ac].* = g_mianji_t.*
              CLOSE i020_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_mianji[l_ac].a,-263,1)
              LET g_mianji[l_ac].* = g_mianji_t.*
           ELSE
                        UPDATE mianji SET
                               a=g_mianji[l_ac].a,
                               b=g_mianji[l_ac].b,
                               c=g_mianji[l_ac].d,
                               d=g_mianji[l_ac].d,
                               e=g_mianji[l_ac].e,
                               f=g_mianji[l_ac].f
                         WHERE CURRENT OF i020_bcl
              IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_mianji[l_ac].rmk01,SQLCA.sqlcode,0) # FUN-660111
                 CALL cl_err3("upd","mianji",g_mianji_t.a,"",SQLCA.sqlcode,"","",1) # FUN-660111
                  LET g_mianji[l_ac].* = g_mianji_t.*
                  DISPLAY g_mianji[l_ac].* TO s_mianji[l_sl].*
              ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i020_bcl
                  COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()                                               
            IF INT_FLAG THEN                 #900423                            
               CALL cl_err('',9001,0)                                           
               LET INT_FLAG = 0                                                 
               #CKP
               IF p_cmd='u' THEN
                  LET g_mianji[l_ac].* = g_mianji_t.*                                    
            #FUN-D40030--add--str--
               ELSE
                  CALL g_mianji.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE i020_bcl                                                   
               ROLLBACK WORK                                                    
               EXIT INPUT                                                       
            END IF                                                              
          #CKP
          #LET g_mianji_t.* = g_mianji[l_ac].*          # 900423
            LET l_ac_t = l_ac                                                   
            CLOSE i020_bcl                                                      
            COMMIT WORK            
 
        ON ACTION CONTROLN
            CALL i020_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmk01) AND l_ac > 1 THEN
                LET g_mianji[l_ac].* = g_mianji[l_ac-1].*
                NEXT FIELD a
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
 
    CLOSE i020_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i020_b_askkey()
    CLEAR FORM
    CALL g_mianji.clear()
    CONSTRUCT g_wc2 ON a,b,c,d
            FROM s_mianji[1].a,s_mianji[1].b,s_mianji[1].c,s_mianji[1].d
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
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i020_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql =
        "SELECT a,b,c,d,e,f ",
        " FROM mianji",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i020_pb FROM g_sql
    DECLARE rmk_curs CURSOR FOR i020_pb
 
    CALL g_mianji.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rmk_curs INTO g_mianji[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_mianji.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_mianji TO s_mianji.* ATTRIBUTE(COUNT=g_rec_b)
 
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
 
   
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i020_out()
    DEFINE
        l_mianji           RECORD LIKE mianji.*,
        l_i             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690010 VARCHAR(20)
        l_za05          LIKE type_file.chr1000                #  #No.FUN-690010 VARCHAR(40)
    ## --> FUN-86001
    DEFINE sr    RECORD
         a       LIKE mianji.a,   #不良現象代碼
         b       LIKE mianji.b,   #不良現象說明
         c       LIKE mianji.c,    #碼別
         d       LIKE mianji.d,
         e       LIKE mianji.e,
         f       LIKE mianji.f
                 END RECORD,
           l_n   LIKE type_file.num5
    ## <-- FUN-86001
   
    CALL cl_del_data(l_table)  ##CR(2) FUN-860018
 
    INITIALIZE l_mianji.* TO NULL      #900423
    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang #No.TQC-5C0064
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog ##FUN-860018 CR(2)
 
    ## --> FUN-860018 CR(3)
    ## 原本sql不適用，所以整個重寫
    LET g_sql = " SELECT * FROM mianji WHERE a= ? ",
                "    AND ",g_wc2 CLIPPED," ORDER BY a " 
 
    PREPARE i020_p2 FROM g_sql
    DECLARE i020_co2 CURSOR FOR i020_p2
   
    FOR l_i = 1 TO 2 STEP 1
       LET l_n = 0
       FOREACH i020_co2 USING l_i INTO l_mianji.*
          IF SQLCA.sqlcode THEN
             CALL cl_err('foreach i020_co2:',SQLCA.sqlcode,1)
             EXIT FOREACH
          END IF
 
          LET l_n = l_n + 1
          IF l_n = 1 THEN
             INITIALIZE sr.* TO NULL
            
             LET sr.a = l_mianji.a
             LET sr.b = l_mianji.b
             LET sr.c = l_mianji.c
             LET sr.d = l_mianji.d
             LET sr.e = l_mianji.e
             LET sr.f = l_mianji.f
             CONTINUE FOREACH
          ELSE
             LET sr.a = l_mianji.a
             LET sr.b = l_mianji.b
             LET sr.c = l_mianji.c
             LET sr.d = l_mianji.d
             LET sr.e = l_mianji.e
             LET sr.f = l_mianji.f
          END IF
 
          EXECUTE insert_prep USING sr.a ,sr.b,sr.c,sr.d,sr.e,sr.f
                                                
          LET l_n = 0
       END FOREACH
       IF l_n = 1 THEN   ##代表有一筆是沒有第二個record的
          EXECUTE insert_prep USING sr.a ,sr.b,sr.c,sr.d,sr.e,sr.f
       END IF
    END FOR
    ## <-- FUN-860018 CR(3)
 
    ## --> FUN-860018 CR(4)
    ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> **** ##
    LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
    #是否列印選擇條件
    IF g_zz05 = 'Y' THEN
       LET g_str = cl_wcchp(g_wc2,"a,b,c,d,e,f")
    ELSE
       LET g_str = ''
    END IF
    CALL cl_prt_cs3('csfi010','csfi010',g_sql,g_str)
    ## <-- FUN-860018 CR(4)
END FUNCTION
 
#No.FUN-570109 --start                                                          
FUNCTION i020_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                           #No.FUN-690010 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("a",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i020_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                           #No.FUN-690010 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("a",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570109 --end           
#No.FUN-870144
